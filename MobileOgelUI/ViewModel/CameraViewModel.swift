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
    private var coreMLManager = CoreMLManager()
    
    // handle logic related to showing instructions
    func handleInstructions() {
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            isShowingInstructions = true
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        } else {
            isShowingInstructions = false
        }
    }
    
    // handle scan button logic
    func launchCamera(){
        isImagePickerPresented = true
        loadCamera = false
        isShowingInstructions = false
    }
    
    // send captured image to model for processing
    func processCapturedImage() -> [LegoPiece] {
            if let image = capturedImage {
                print("in process captured image")
                coreMLManager.classifyImage(image)
            }
        }
}
