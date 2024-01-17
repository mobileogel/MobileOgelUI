//
//  ColourModule.swift
//  MobileOgelUI
//
//  Created by Guy Morgenshtern on 2024-01-17.
//

import Foundation
import CoreImage
import UIKit
import Vision

class ColourModule {
    var rgbDict: [String: UIColor] = [:]

    init() {
        if let url = Bundle.main.url(forResource: "lego_colours", withExtension: "csv") {
            if let data = try? String(contentsOf: url) {
                let rows = data.components(separatedBy: "\n")
                for row in rows.dropFirst(2) {
                    let columns = row.components(separatedBy: ",")
                    if columns.count >= 5 {
                        let name = columns[1]
                        if let rgbValues = columns.suffix(3).compactMap({ Int($0) }) {
                            let color = UIColor(
                                calibratedRed: CGFloat(rgbValues[0]) / 255.0,
                                green: CGFloat(rgbValues[1]) / 255.0,
                                blue: CGFloat(rgbValues[2]) / 255.0,
                                alpha: 1.0
                            )
                            rgbDict[name] = color
                        }
                    }
                }
            }
        }
    }

    func euclideanDistance(color1: UIColor, color2: UIColor) -> CGFloat {
        let components1 = color1.cgColor.components!
        let components2 = color2.cgColor.components!
        return sqrt(
            zip(components1, components2).map { pow(($0.0 - $0.1), 2) }.reduce(0, +)
        )
    }

    func findClosestColor(inputColor: UIColor) -> String? {
        var minDistance = CGFloat.infinity
        var closestColor: UIColor?

        for (colorName, color) in rgbDict {
            let distance = euclideanDistance(color1: inputColor, color2: color)
            if distance < minDistance {
                minDistance = distance
                closestColor = color
            }
        }

        return rgbDict.first(where: { $0.value == closestColor })?.key
    }

    func printColourRGBPair() {
        for (name, color) in rgbDict {
            print("Name: \(name), RGB: \(color.cgColor.components!)")
        }
    }

    func findMode(colours: [String]) -> [String] {
        let counter = NSCountedSet(array: colours)
        var modeList: [String] = []
        var maxCount = 0

        for item in counter {
            let count = counter.count(for: item)
            if count == maxCount {
                modeList.append(item as! String)
            } else if count > maxCount {
                maxCount = count
                modeList = [item as! String]
            }
        }

        return modeList
    }

    func determineIdealSampleSize(population: Int, marginOfError: CGFloat = 0.01) -> Int {
        return Int(Double(population) / (1 + Double(population) * pow(Double(marginOfError), 2))) + 1
    }
    
    func buildProbabilityGradient(img: UIImage, observation: VNRecognizedObjectObservation, gradientInterval: CGFloat = 0.10) -> [UIColor] {
        var leftBoundary = observation.boundingBox.origin.x
        var rightBoundary = observation.boundingBox.origin.x + observation.boundingBox.size.width

        let upBoundary = observation.boundingBox.origin.y
        let downBoundary = observation.boundingBox.origin.y + observation.boundingBox.size.height

        let heightInterval = Int((downBoundary - upBoundary) * (gradientInterval / 2))
        let widthInterval = Int((rightBoundary - leftBoundary) * (gradientInterval / 2))

        var pixelList: [UIColor] = []

        for i in 0..<Int(1 / gradientInterval) {
            let leftRectangle = CGRect(x: leftBoundary, y: upBoundary, width: CGFloat(widthInterval), height: downBoundary - upBoundary)
            let leftPixels = img.crop(rect: leftRectangle)
            var pixelValues = getRGBValues(image: leftPixels)
            for colour in pixelValues {
                pixelList.append(UIColor(red: CGFloat(colour.0 / 255), green: CGFloat(colour.1 / 255), blue: CGFloat(colour.2 / 255), alpha: 1.0))
            }

            let rightRectangle = CGRect(x: rightBoundary - CGFloat(widthInterval), y: upBoundary, width: CGFloat(widthInterval), height: downBoundary - upBoundary)
            let rightPixels = img.crop(rect: rightRectangle)
            pixelValues = getRGBValues(image: rightPixels)
            for colour in pixelValues {
                pixelList.append(UIColor(red: CGFloat(colour.0 / 255), green: CGFloat(colour.1 / 255), blue: CGFloat(colour.2 / 255), alpha: 1.0))
            }

            var upperRectangle = CGRect(x: leftBoundary + CGFloat(widthInterval), y: upBoundary, width: rightBoundary - leftBoundary - CGFloat(widthInterval * 2), height: CGFloat(heightInterval)) 
            var upperPixels = img.crop(rect: upperRectangle)
            var upperPixelValues = upperPixels.flatMap { getRGBValues(from: $0) }
            pixelList.append(contentsOf: Array(repeating: upperPixelValues, count: i + 1))

            var lowerRectangle = CGRect(x: leftBoundary + CGFloat(widthInterval), y: downBoundary - CGFloat(heightInterval), width: rightBoundary - leftBoundary - CGFloat(widthInterval * 2), height: CGFloat(heightInterval))
            var lowerPixels = img.crop(rect: lowerRectangle)
            var lowerPixelValues = lowerPixels.flatMap { getRGBValues(from: $0) }
            pixelList.append(contentsOf: Array(repeating: lowerPixelValues, count: i + 1))

            leftBoundary += CGFloat(widthInterval)
            rightBoundary -= CGFloat(widthInterval)
            upBoundary += CGFloat(heightInterval)
            downBoundary -= CGFloat(heightInterval)
        }

        return pixelList
    }
    
    public func determineColourByRandomSample(img: UIImage, observation: VNRecognizedObjectObservation, sampleRate: CGFloat = 0.05) -> String? {
        let boundingBox = observation.boundingBox
        let boxHeight = boundingBox.size.height
        let boxWidth =  boundingBox.size.width
        

        let xmin = boundingBox.origin.x
        let xmax = boundingBox.origin.x + boxWidth
        
        let ymin = boundingBox.origin.y
        let ymax = boundingBox.origin.y + boxHeight
        
        let numPixelsToSample = determineIdealSampleSize(population: boxWidth * boxHeight)
        print("Box size \(boxWidth * boxHeight) pixels ")
        print("Sampling \(numPixelsToSample) pixels")

        let blurredImage = img.gaussianBlur(radius: 5)

        let allColoursWithProbabilityGradient = buildProbabilityGradient(img: blurredImage, observation: observation)
        print("Gradient size: \(allColoursWithProbabilityGradient.count)")
        var closestColourList: [String] = []

        for _ in 0..<numPixelsToSample {
            let randomIndex = Int.random(in: 0..<allColoursWithProbabilityGradient.count)
            let rgba = allColoursWithProbabilityGradient[randomIndex]
            if let colour = findClosestColor(inputColor: rgba) {
                closestColourList.append(colour)
            }
        }

        return findMode(colours: closestColourList).first
    }
    
    
    func getRGBValues(image: UIImage) -> [(Int, Int, Int)] {
        guard let cgImage = image.cgImage else {
            return nil
        }

        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8

        var pixels = [UInt8](repeating: 0, count: width * height * bytesPerPixel)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        guard let context = CGContext(data: &pixels,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        var result = [[(Int, Int, Int)]]()

        for y in 0..<height {
            var row = [(Int, Int, Int)]()
            for x in 0..<width {
                let pixelIndex = (y * width + x) * bytesPerPixel
                let red = Int(pixels[pixelIndex])
                let green = Int(pixels[pixelIndex + 1])
                let blue = Int(pixels[pixelIndex + 2])
                row.append((red, green, blue))
            }
            result.append(row)
        }

        return result
    }
}

extension UIImage {
    func crop(rect: CGRect) -> UIImage {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return [] }
        let croppedCGImage = cgImage.cropping(to: rect)
        let croppedImage = UIImage(cgImage: croppedCGImage!, size: rect.size)
        return croppedImage
    }
}







