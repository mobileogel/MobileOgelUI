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
            viewModel.isImagePickerPresented = false
            if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") { //only show if first launch
                viewModel.isShowingInstructions = true
            }
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                //viewModel.capturedImage = image

               
                let boundingBoxRect = CGRect(
                    x: 549.6420766450465,
                    y: 815.3653321704422,
                    width: 55.41435473412275,
                    height:43.57593084288374
                )
                viewModel.capturedImage = UIImage(named: "sample_image")
                if let cgImage = viewModel.capturedImage?.cgImage {
                    
                    if let croppedCGImage = cgImage.cropping(to: boundingBoxRect) {
                        // viewModel.capturedImage = UIImage(cgImage: cgImage.cropping(to: CGRect(x:259.0,y: 412.0, width: 153.0, height: 302.0))!)
                        viewModel.capturedImage = UIImage(cgImage: croppedCGImage)
                        
                    }
                }
                
//                (0.26274413615465164, 0.23992222232404375, 0.15615235269069672, 0.07860683113242845)
                
                
            }

            viewModel.isImagePickerPresented = false
            // nav to CapturedImageView
            usePhotoNav?()
        }
    }
}
