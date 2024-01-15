//
//  CameraViewModel.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill on 2023-12-25.
//

import Foundation
import UIKit
import Observation

@Observable class CameraViewModel {
    var isShowingInstructions = true
    var capturedImage: UIImage?
    var isImagePickerPresented = false
    var isImageSelected = false
    
    // handle logic related to showing instructions
    func handleInstructions() {
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            isShowingInstructions = true
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        } else {
            isShowingInstructions = false
        }
    }
}
