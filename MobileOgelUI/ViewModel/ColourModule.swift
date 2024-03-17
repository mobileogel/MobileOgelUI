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
        if let url = Bundle.main.url(forResource: "colors2", withExtension: "csv") {
            if let data = try? String(contentsOf: url) {
                let rows = data.components(separatedBy: "\n")
                for row in rows.dropFirst(1) { // Drop the header row
                    let columns = row.components(separatedBy: ",")
                    //print(columns)
                    if columns.count >= 4 {
                        let name = columns[0]
                        let red = Int(columns[1]) ?? 0
                        let green = Int(columns[2]) ?? 0
                        let blue = Int(columns[3]) ?? 0
                        
//                        print("pes")
//                        print(red, blue, green)
                        let color = UIColor(
                            red: CGFloat(red) / 255.0,
                            green: CGFloat(green) / 255.0,
                            blue: CGFloat(blue) / 255.0,
                            alpha: 1.0
                        )
                        
                        rgbDict[name] = color
                    }
                }
            }
        }
//        print("ge")
//        print(rgbDict)
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
        var closestColorName: String?

        for (colorName, color) in rgbDict {
            let distance = euclideanDistance(color1: inputColor, color2: color)
            if distance < minDistance {
                minDistance = distance
                closestColor = color
                closestColorName = colorName
            }
        }
        
        print(inputColor, closestColor, rgbDict.first(where: { $0.value == closestColor })?.key, closestColorName)
        //print(rgbDict.first(where: { $0.value == closestColor })?.key)
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
        
        print("colour list", colours)
        print("mode list: ", modeList)
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
        let heightInterval = boundingBoxHeight * (gradientInterval / 2)

        for i in 0..<Int(1/gradientInterval) {
            let leftBox = CGRect(x: Int(xStart), y: Int(yStart), width: Int(widthInterval), height: Int(boundingBoxHeight))
            if let leftCroppedImage = img.cropping(to: leftBox) {
                let pixelValues = extractColors(image: leftCroppedImage)
                pixelList += pixelValues
            }

            let rightBox = CGRect(x: Int(xStart + boundingBoxWidth - widthInterval), y: Int(yStart), width: Int(widthInterval), height: Int(boundingBoxHeight))
            if let rightCroppedImage = img.cropping(to: rightBox) {
                let pixelValues = extractColors(image: rightCroppedImage)
                pixelList += pixelValues
            }

            let upperBox = CGRect(x: Int(xStart + widthInterval), y: Int(yStart + boundingBoxHeight - heightInterval), width: Int(boundingBoxWidth - (2 * widthInterval)), height: Int(heightInterval))
            if let upperCroppedImage = img.cropping(to: upperBox) {
                let pixelValues = extractColors(image: upperCroppedImage)
                pixelList += pixelValues
            }

            let lowerBox = CGRect(x: Int(xStart + widthInterval), y: Int(yStart), width: Int(boundingBoxWidth - (2 * widthInterval)), height: Int(heightInterval))
            if let lowerCroppedImage = img.cropping(to: lowerBox) {
                let pixelValues = extractColors(image: lowerCroppedImage)
                pixelList += pixelValues
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

        DetectionDataManager.shared.updateData(with: ["capturedImage": UIImage(cgImage: img)])
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
//        let ciImg = CIImage(cgImage: image)
//        let blur = CIFilter(name: "CIGaussianBlur")
//        blur?.setValue(ciImg, forKey: kCIInputImageKey)
//        blur?.setValue(blurRadius, forKey: kCIInputRadiusKey)
//        if let outputImg = blur?.outputImage {
//            return convertCIImageToCGImage(inputImage: outputImg)
//            
//        }
//        return nil
        
        return image
    }


    func extractColors(image: CGImage) -> [UIColor] {
        var colors: [UIColor] = []

        // Get image dimensions
        let width = image.width
        let height = image.height

        // Create a bitmap context to draw the image
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)

        guard let context = context else {
            return colors
        }

        // Draw the image into the context
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))

        // Get pixel data from the context
        if let data = context.data {
            let buffer = data.bindMemory(to: UInt32.self, capacity: width * height)
            for y in 0..<height {
                for x in 0..<width {
                    let offset = y * width + x
                    let color = buffer[offset]
                    let blue = CGFloat((color >> 16) & 0xFF) / 255.0
                    let green = CGFloat((color >> 8) & 0xFF) / 255.0
                    let red = CGFloat(color & 0xFF) / 255.0
                    let alpha = CGFloat((color >> 24) & 0xFF) / 255.0
                
                    let pixelColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)

                    colors.append(pixelColor)
                }
            }
        }

        return colors
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

