//
//  CameraView.swift
//  MobileOgelUI
//
//  Contributors: Shuvaethy Neill and Harsimran Kanwar
//

import Foundation
import UIKit
import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    var viewModel: CameraViewModel
    var usePhotoNav: (() -> Void)? // to handle use photo button action
    
    typealias UIViewControllerType = UIImagePickerController
    
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UIViewControllerType()
        viewController.delegate = context.coordinator
        viewController.sourceType = .camera
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // not in use rn
    }
    
    func makeCoordinator() -> CameraView.Coordinator {
        return Coordinator(viewModel: viewModel, usePhotoNav: usePhotoNav)
    }
    
    // handle cancel and use photo actions
    // bridge between UIKit UIImagePickerController and CameraViewModel
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var viewModel: CameraViewModel
        var usePhotoNav: (() -> Void)?
        
        init(viewModel: CameraViewModel, usePhotoNav: (() -> Void)?) {
            self.viewModel = viewModel
            self.usePhotoNav = usePhotoNav
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            viewModel.capturedImage = nil

            viewModel.isShowingInstructions = true
            
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
                
                viewModel.capturedImage = Util.resizeImageToModelStandard(image: image)!
            }

            viewModel.isImagePickerPresented = false
            // nav to CapturedImageView
            usePhotoNav?()
        }
    }
}
