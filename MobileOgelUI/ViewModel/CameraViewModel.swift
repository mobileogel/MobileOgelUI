//
//  CameraViewModel.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill on 2023-12-25.
//

import Foundation
import UIKit

class CameraViewModel: ObservableObject {
    @Published var isShowingInstructions = true
    @Published var capturedImage: UIImage?
    @Published var isImagePickerPresented = false
    @Published var loadCamera = false
    
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
