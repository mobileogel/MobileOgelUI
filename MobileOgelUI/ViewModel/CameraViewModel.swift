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
}
