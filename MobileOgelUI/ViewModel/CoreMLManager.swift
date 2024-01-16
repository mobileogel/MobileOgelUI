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
    private let modelM: LegoDetectorNew
    let config = MLModelConfiguration()
    
    init() {
        
         guard let loadedModel = try? LegoDetectorNew(configuration: MLModelConfiguration()) else {
         fatalError("Unable to load the CoreML model")
         }
         self.modelM = loadedModel
         
        
    }
    
    func classifyImage(_ image: UIImage = UIImage(named: "sample_image")!) {
        let model = try! LegoDetectorNew(configuration: MLModelConfiguration())
        
        guard let visModel = try? VNCoreMLModel(for: model.model) else {
            fatalError("Failed to load custom vision model")
        }
        
        let request = VNCoreMLRequest(model: visModel)
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("Failed to create CIImage from input image")
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage )
        
        try! handler.perform([request])
        
        print(request.results ?? "uh oh")
        
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
