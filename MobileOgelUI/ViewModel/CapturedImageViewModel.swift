//
//  CapturedImageViewModel.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill on 2024-01-25.
//

import Foundation
import UIKit

@Observable class CapturedImageViewModel {
    var isProcessing = false
    private var coreMLManager = CoreMLManager()
    let capturedImage: UIImage?
    
    init(capturedImage: UIImage?) {
        self.capturedImage = capturedImage
    }
    
    func processCapturedImage(completion: @escaping () -> Void) {
        guard let image = capturedImage else {
            print("Captured image is nil")
            completion()
            return
        }
        
        isProcessing = true
        
        // asynchronous image classification
        DispatchQueue.global().async { [self] in
            LegoPieceDBManager.shared.deleteAllPieces()
            
            let detectedPieces = coreMLManager.classifyImage(image)
            
            // persist detected pieces
            if !detectedPieces.isEmpty {
                for piece in detectedPieces {
                    LegoPieceDBManager.shared.addPiece(piece: piece)
                }
            }
            
            // update UI on main thread
            DispatchQueue.main.async {
                self.isProcessing = false
                completion()
            }
        }
    }
}
