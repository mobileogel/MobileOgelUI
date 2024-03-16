//
//  DetectionViewModel.swift
//  MobileOgelUI
//
//  Created by Guy Morgenshtern on 2024-03-14.
//

import Foundation
import UIKit
import Vision

@Observable class DetectionViewModel {
    var isProcessing = false
    private var coreMLManager = CoreMLManager()
    let capturedImage: UIImage?
    let detections: [VNRecognizedObjectObservation]?
    
    init() {
        self.capturedImage = DetectionDataManager.shared.getSharedData().capturedImage
        self.detections = DetectionDataManager.shared.getSharedData().modelResults
    }
    
    
}

