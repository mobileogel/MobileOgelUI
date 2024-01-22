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
    
    func classifyImage(_ image: UIImage) -> [LegoPiece] {
        var legoPieces: [LegoPiece] = []
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
            
            legoPieces = self.buildLegoPieceList(image: image, results: results)
            
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
        
        return legoPieces
    }
    
    func infer_colours(img: CGImage, detection: VNRecognizedObjectObservation) -> String {
        let cm = ColourModule()
        
        return cm.determineColourByRandomSample(img: img, observation: detection)!
        
    }
    
    func buildLegoPieceList(image: UIImage, results: [VNRecognizedObjectObservation]) -> [LegoPiece] {
        
        struct BrickKey: Hashable {
            let label: String
            let color: LegoColour
        }
        
        // Initialize an empty dictionary to store the count of each Lego piece
        var bricksDetected: [BrickKey: Int] = [:]
        
        var bricksDetectedObjects: [LegoPiece] = []
        
        for detectedPiece in results {
            
            guard let cgImg = image.cgImage else {
                print("Error converting image to CGImage")
                continue
            }
            
            let pieceColour = self.infer_colours(img: cgImg, detection: detectedPiece)
            
            if let label = detectedPiece.labels.first?.identifier as? String,
               let legoColor = LegoColour(rawValue: pieceColour) {
                
                let potentialKey = BrickKey(label: label, color: legoColor)
                
                bricksDetected[potentialKey, default: 0] += 1
            }
        }
        
        // Convert the detected pieces into LegoPiece objects
        for (piece, quantity) in bricksDetected {
        
            print(piece.label)
            let legoPiece = LegoPiece(
//                imageName: Util.getRandomImage(withX: piece.label)!,
                imageName: Util.getImageNameOrPlaceHolder(withX: piece.label),
                pieceName: ClassToNameMap.getMappedValue(forKey: piece.label),
                quantity: quantity,
                officialColour: piece.color
            )
            bricksDetectedObjects.append(legoPiece)
        }
        return bricksDetectedObjects
    }
}
