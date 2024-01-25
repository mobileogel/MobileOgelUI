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
        if let url = Bundle.main.url(forResource: "colors", withExtension: "csv") {
            if let data = try? String(contentsOf: url) {
                let rows = data.components(separatedBy: "\n")
                for row in rows.dropFirst(2) {
                    let columns = row.components(separatedBy: ",")
                    if columns.count >= 5 {
                        let name = columns[1]
                        let rgbValues = columns.suffix(3).compactMap({ Int($0) })
                        let color = UIColor(
                            red: CGFloat(rgbValues[0]) / 255.0,
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
    //REMEMBER THE COORD SYSTEM IS FLIPPED, DOUBLE CHECK THE CROP VALUES
    func buildProbabilityGradient(img: CGImage, observation: VNRecognizedObjectObservation, gradientInterval: CGFloat = 0.25) -> [UIColor] {
        
                
        var pixelList: [UIColor] = []
        
        var xStart = observation.boundingBox.origin.x * CGFloat(img.width)
        var yStart =  (1 - observation.boundingBox.origin.y - observation.boundingBox.height) * CGFloat(img.height)
        let boundingBoxWidth = observation.boundingBox.width * CGFloat(img.width)
        let boundingBoxHeight = observation.boundingBox.height * CGFloat(img.height)
        
        let widthInterval = boundingBoxWidth * (gradientInterval / 2)
        let heightInterval = boundingBoxWidth * (gradientInterval / 2)
        
        let boundBoxRect = CGRect(
            x: xStart,
            y: yStart,
            width: boundingBoxWidth,
            height: boundingBoxHeight
        )
        
        print(observation.boundingBox)
        print(boundBoxRect)


        for i in 0..<Int(1/gradientInterval) {
            
            let leftBox = CGRect(x: Int(xStart), y: Int(yStart), width: Int(widthInterval), height: Int(boundingBoxHeight))
            if let leftCroppedImage = img.cropping(to: leftBox) {
//                print("LEFT CROPPED \(leftCroppedImage)")
                let pixelValues = extractColors(from: leftCroppedImage)
                let repeatedValues = [[UIColor]](repeating: pixelValues, count: i+1).flatMap{$0}
                pixelList += repeatedValues
            }

            let rightBox = CGRect(x: Int(xStart + boundingBoxWidth - widthInterval), y: Int(yStart), width: Int(widthInterval), height: Int(boundingBoxHeight))
//            print("rb \(rightBox)")
            if let rightCroppedImage = img.cropping(to: rightBox) {
                let pixelValues = extractColors(from: rightCroppedImage)
                
                let repeatedValues = [[UIColor]](repeating: pixelValues, count: i+1).flatMap{$0}
                pixelList += repeatedValues
            }

            
            let upperBox = CGRect(x: Int(xStart + widthInterval), y: Int(yStart + boundingBoxHeight - heightInterval), width: Int((boundingBoxWidth - (2 * widthInterval))), height: Int(heightInterval))
//            print("ub \(upperBox)")
            if let upperCroppedImage = img.cropping(to: upperBox) {
                let pixelValues = extractColors(from: upperCroppedImage)
                
                let repeatedValues = [[UIColor]](repeating: pixelValues, count: i+1).flatMap{$0}
                pixelList += repeatedValues
            }
            
            
            let lowerBox = CGRect(x: Int((xStart + widthInterval)), y: Int(yStart), width: Int((boundingBoxWidth - (2 * widthInterval))), height: Int(heightInterval))
//            print("lowb \(lowerBox)")
            if let lowerCroppedImage = img.cropping(to: lowerBox) {
                let pixelValues = extractColors(from: lowerCroppedImage)
                
                let repeatedValues = [[UIColor]](repeating: pixelValues, count: i+1).flatMap{$0}
                pixelList += repeatedValues
            }

            
            xStart += widthInterval
            
            yStart += heightInterval
            
        }
        
        return pixelList
    }
    
    
    public func determineColourByRandomSample(img: CGImage, observation: VNRecognizedObjectObservation, sampleRate: CGFloat = 0.05) -> String? {
        let boundingBox = observation.boundingBox
    
        let boxHeight = Int(boundingBox.size.height * CGFloat(img.height))
        let boxWidth =  Int(boundingBox.size.width * CGFloat(img.width))

        let numPixelsToSample = determineIdealSampleSize(population: Int(boxWidth * boxHeight))
        print("Box size \(boxWidth * boxHeight) pixels ")
        print("Sampling \(numPixelsToSample) pixels")

       
        
        if let blurredImage = blurImage(img, blurRadius: 5.0) {
            print("blurred")
            let allColoursWithProbabilityGradient = buildProbabilityGradient(img: blurredImage, observation: observation)
            print("Gradient size: \(allColoursWithProbabilityGradient.count)")
            var closestColourList: [String] = []
            if (allColoursWithProbabilityGradient.count > 0) {
                for _ in 0..<numPixelsToSample {
                    let randomIndex = Int.random(in: 0..<allColoursWithProbabilityGradient.count)
                    let rgba = allColoursWithProbabilityGradient[randomIndex]
                    if let colour = findClosestColor(inputColor: rgba) {
                        
                        closestColourList.append(colour)
                    }
                }

            }
            
            return findMode(colours: closestColourList).first
        } else {
            print("did not blur properly")
            return nil
        }
    
    }
    
    
    func blurImage(_ image: CGImage, blurRadius: CGFloat) -> CGImage? {
        let ciImg = CIImage(cgImage: image)
        let blur = CIFilter(name: "CIGaussianBlur")
        blur?.setValue(ciImg, forKey: kCIInputImageKey)
        blur?.setValue(blurRadius, forKey: kCIInputRadiusKey)
        if let outputImg = blur?.outputImage {
            return convertCIImageToCGImage(inputImage: outputImg)
            
        }
        return nil
    }
    
    func extractColors(from cgImage: CGImage) -> [UIColor] {
        var pixelColours: [UIColor] = []
        for x in 0..<cgImage.width {
            for y in 0..<cgImage.height {
                let pixelData = cgImage.dataProvider!.data
                let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

                let pixelInfo: Int = ((cgImage.width * y) + x) * 4
                

                let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
                let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
                let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
                let a = 1.0

                pixelColours.append(UIColor(red: r, green: g, blue: b, alpha: a))
            }
        }

        return pixelColours
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
            return cgImage
        } else {
            print("did not convert properly")
            return nil
        }
        
    }
}

