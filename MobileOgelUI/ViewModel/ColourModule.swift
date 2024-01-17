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
        if let url = Bundle.main.url(forResource: "../res/colors", withExtension: "csv") {
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
    
    func buildProbabilityGradient(img: CGImage, observation: VNRecognizedObjectObservation, gradientInterval: CGFloat = 0.10) -> [UIColor] {
        
        
        var leftBoundary = CGFloat(observation.boundingBox.origin.x) * CGFloat(img.width)
        var rightBoundary = CGFloat(observation.boundingBox.origin.x + observation.boundingBox.size.width) * CGFloat(img.width)

        var upBoundary = CGFloat(observation.boundingBox.origin.y) * CGFloat(img.width)
        var downBoundary = CGFloat(observation.boundingBox.origin.y + observation.boundingBox.size.height) * CGFloat(img.width)

        let heightInterval = CGFloat((downBoundary - upBoundary) * (gradientInterval / 2)) 
        let widthInterval = CGFloat((rightBoundary - leftBoundary) * (gradientInterval / 2))

        var pixelList: [UIColor] = []

        for i in 0..<Int(1/gradientInterval) {
            
            let leftBox = CGRect(x: leftBoundary, y: upBoundary, width: widthInterval, height: observation.boundingBox.size.height)
            
            if let leftCroppedImage = img.cropping(to: leftBox) {
                let pixelValues = extractColors(from: leftCroppedImage)
                let repeatedValues = [[UIColor]](repeating: pixelValues, count: i+1).flatMap{$0}
                pixelList += repeatedValues
            }
           
            

            
            let rightBox = CGRect(x: rightBoundary - widthInterval, y: upBoundary, width: widthInterval, height: observation.boundingBox.size.height)
            if let rightCroppedImage = img.cropping(to: rightBox) {
                let pixelValues = extractColors(from: rightCroppedImage)
                
                let repeatedValues = [[UIColor]](repeating: pixelValues, count: i+1).flatMap{$0}
                pixelList += repeatedValues
            }

            
            let upperBox = CGRect(x: leftBoundary + widthInterval, y: upBoundary, width: observation.boundingBox.size.width - (2 * widthInterval), height: heightInterval)
            if let upperCroppedImage = img.cropping(to: upperBox) {
                let pixelValues = extractColors(from: upperCroppedImage)
                
                let repeatedValues = [[UIColor]](repeating: pixelValues, count: i+1).flatMap{$0}
                pixelList += repeatedValues
            }
            
            
            let lowerBox = CGRect(x: leftBoundary + widthInterval, y: downBoundary - heightInterval, width: observation.boundingBox.size.width - (2 * widthInterval), height: heightInterval)
            if let lowerCroppedImage = img.cropping(to: lowerBox) {
                let pixelValues = extractColors(from: lowerCroppedImage)
                
                let repeatedValues = [[UIColor]](repeating: pixelValues, count: i+1).flatMap{$0}
                pixelList += repeatedValues
            }

            
            leftBoundary += widthInterval
            rightBoundary -= widthInterval
            
            upBoundary += heightInterval
            downBoundary -= heightInterval
            
        }
        
        return pixelList
    }
    
    
    public func determineColourByRandomSample(img: CGImage, observation: VNRecognizedObjectObservation, sampleRate: CGFloat = 0.05) -> String? {
        let boundingBox = observation.boundingBox
    
        let boxHeight = Int(boundingBox.size.height * CGFloat(img.height))
        let boxWidth =  Int(boundingBox.size.width * CGFloat(img.width))
        
        
        print(boundingBox)
        print(boxWidth)
        print(boxHeight)
        

        
        let numPixelsToSample = determineIdealSampleSize(population: Int(boxWidth * boxHeight))
        print("Box size \(boxWidth * boxHeight) pixels ")
        print("Sampling \(numPixelsToSample) pixels")

       
        
        if let blurredImage = blurImage(img, blurRadius: 5.0) {
            
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
        
        return nil
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
        var colors: [UIColor] = []

        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let rawData = UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * bytesPerPixel)

        defer {
            rawData.deallocate()
        }

        let context = CGContext(
            data: rawData,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        )

        guard let cgContext = context else {
            // Handle the case where CGContext cannot be created
            return colors
        }

        for y in 0..<height {
            for x in 0..<width {
                let byteIndex = (bytesPerRow * y) + x * bytesPerPixel
                let red = CGFloat(rawData[byteIndex]) / 255.0
                let green = CGFloat(rawData[byteIndex + 1]) / 255.0
                let blue = CGFloat(rawData[byteIndex + 2]) / 255.0
                let alpha = CGFloat(rawData[byteIndex + 3]) / 255.0

                let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                colors.append(color)
            }
        }

        return colors
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
            return cgImage
        }
        return nil
    }
}








