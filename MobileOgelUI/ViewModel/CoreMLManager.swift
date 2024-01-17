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
    private let model: VNCoreMLModel
    
    init() {
        
        // load converted coreML model
        guard let loadedModel = try? LegoDetectorNew(configuration: MLModelConfiguration()) else {
            fatalError("Failed to load custom vision model")
        }
        
        // create VNCoreMLModel from loaded model
        guard let visModel = try? VNCoreMLModel(for: loadedModel.model) else {
            fatalError("Failed to create a `VNCoreMLModel` instance.")
        }
        
        self.model = visModel
        
    }
    
    func classifyImage(_ image: UIImage) {
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            // handle completion of request
            if let error = error {
                print("Error in CoreML request: \(error)")
                return
            }
            
            // check that we get the expected results
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                print("VNRequest produced the wrong result type: \(type(of: request.results)).")
                return
            }
            
            print(results)
            
            let predictedPieces = results.map { observation in
                observation.labels.first?.identifier
            }
            
            print("Predicted pieces: \(predictedPieces)")
            
            
        }
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("Failed to create CIImage from input image")
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        do {
            try handler.perform([request])
        } catch {
            print("Error performing image request: \(error)")
        }
    }
    
    func infer_colours(img: UIImage, results: [VNRecognizedObjectObservation]) {
        let cm = ColourModule()
        for detectedPiece in results {
            // Access individual observation properties here
            let boundingBox = detectedPiece.boundingBox
            let confidence = detectedPiece.confidence
            
            cm.determineColourByRandomSample(img: img, observation: detectedPiece)
            
            
            
        }
    }
}
