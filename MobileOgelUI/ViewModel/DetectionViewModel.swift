//
//  DetectionViewModel.swift
//  MobileOgelUI
//
//  Created by Guy Morgenshtern on 2024-03-14.
//

import Foundation
import UIKit
import Vision

class DetectionViewModel: ObservableObject {
    @Published var isProcessing = false
    @Published var capturedImage: UIImage?
    @Published var detections: [VNRecognizedObjectObservation]?
    private var coreMLManager = CoreMLManager()

    init() {
        // Initialize with initial shared data
        let initialData = DetectionDataManager.shared.getSharedData()
        capturedImage = initialData.capturedImage
        detections = initialData.modelResults

        // Subscribe to data changes
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataChange), name: Notification.Name("SharedDataDidChange"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func handleDataChange() {
        // Update properties based on new shared data
        let newData = DetectionDataManager.shared.getSharedData()
        capturedImage = newData.capturedImage
        detections = newData.modelResults
    }
}


