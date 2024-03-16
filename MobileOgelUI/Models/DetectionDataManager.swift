//
//  DetectionDataManager.swift
//  MobileOgelUI
//
//  Created by Guy Morgenshtern on 2024-03-14.
//

import Foundation
import UIKit
import Vision

// Shared Data Model
struct SharedData {
    var capturedImage: UIImage?
    var modelResults: [VNRecognizedObjectObservation]?
}

// Centralized Data Manager
class DetectionDataManager {
    static let shared = DetectionDataManager()

        private var sharedData: SharedData = SharedData(capturedImage: nil, modelResults: [])

        func updateData(with data: [String: Any]) {
            for (key, value) in data {
                guard let property = PropertyInfo(rawValue: key) else {
                    assertionFailure("Unknown property: \(key)")
                    continue
                }

                switch property {
                
                case .capturedImage:
                    guard let image = value as? UIImage else {
                        assertionFailure("Invalid value type for 'capturedImage'")
                        continue
                    }
                    sharedData.capturedImage = image
                
                case .modelResults:
                    guard let results = value as? [VNRecognizedObjectObservation] else {
                        assertionFailure("Invalid value type for 'modelResults'")
                        continue
                    }
                    sharedData.modelResults = results
                }
            }

            notifyObservers()
        }

        func getSharedData() -> SharedData {
            return sharedData
        }

        private func notifyObservers() {
            NotificationCenter.default.post(name: Notification.Name("SharedDataDidChange"), object: nil)
        }

        enum PropertyInfo: String {
            case capturedImage
            case modelResults
        }
}
