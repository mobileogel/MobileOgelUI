//
//  CameraViewModel.swift
//  MobileOgelUI
//
//  Contributors: Shuvaethy Neill and Harsimran Kanwar
//

import Foundation
import UIKit
import Observation

@Observable class CameraViewModel {
    var isShowingInstructions = true
    var capturedImage: UIImage?
    var isImagePickerPresented = false
    var isImageSelected = false
    var loadCamera = false

    // handle logic related to showing instructions
    func handleInstructions() {
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            isShowingInstructions = true
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        } else {
            isShowingInstructions = false
        }
    }
    
    //Handle scan button logic
    func launchCamera(){
        isImagePickerPresented = true
        loadCamera = false
        isShowingInstructions = false
    }
    
}
