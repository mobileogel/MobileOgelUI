//
//  CoreMLManager.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill on 2024-01-15.
//

import Foundation
import CoreML
import UIKit
import Vision

class CoreMLManager {
    private let model: LegoDetector
    
    init() {
        guard let loadedModel = try? LegoDetector(configuration: MLModelConfiguration()) else {
            fatalError("Unable to load the CoreML model")
        }
        self.model = loadedModel
    }
    
    func analyzeImage(_ image: UIImage) {
        print("here")
        
        // convert UIImage to CVPixelBuffer
        guard let pixelBuffer = convertToCVPixelBuffer(from: image) else {
            print("Failed to convert UIImage to CVPixelBuffer")
            return
        }
        
        // predict using model
        if let prediction = try? model.prediction(image: pixelBuffer) {
            print("inside prediction")
            print("prediction result: \(prediction.var_1054)")
            
            // iterate through elements of MLMultiArray
            if let multiArray = prediction.var_1054 as? MLMultiArray {
                for index in 0..<multiArray.count {
                    let elementValue = multiArray[index]
                    print("element \(index): \(elementValue)")
                }
            } else {
                print("var_1054 is not an MLMultiArray")
            }
            
            // trying to determine what the output properties are called
            let mirror = Mirror(reflecting: prediction)
            
            /*
             for child in mirror.children {
             print("property: \(child.label ?? "unknown"), value: \(child.value)")
             }
             */
            
            for child in mirror.children {
                if let label = child.label, label == "provider", let provider = child.value as? MLDictionaryFeatureProvider {
                    print("Provider Keys: \(provider.featureNames)")
                }
            }
            
        } else {
            print("Failed to make a prediction")
        }
    }
    
    // needed to convert
    func convertToCVPixelBuffer(from image: UIImage) -> CVPixelBuffer? {
        guard let ciImage = CIImage(image: image) else {
            print("Failed to create CIImage from UIImage")
            return nil
        }
        
        let targetSize = CGSize(width: 640, height: 640)
        let scale = targetSize.width / image.size.width
        let resizedImage = ciImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        
        var pixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault,
                            Int(targetSize.width),
                            Int(targetSize.height),
                            kCVPixelFormatType_32ARGB,
                            nil,
                            &pixelBuffer)
        
        let context = CIContext()
        context.render(resizedImage, to: pixelBuffer!)
        
        return pixelBuffer
    }
}
