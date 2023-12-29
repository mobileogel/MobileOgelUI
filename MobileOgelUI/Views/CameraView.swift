//
//  CameraView.swift
//  MobileOgelUI
//
//  Created by Harsimran Kanwar on 2023-12-29.
//

import SwiftUI
import UIKit

struct CameraView: View {
    @State private var showImagePicker = false
    @State private var capturedImage: UIImage?
    @State private var showCapturedPhoto = false
    
    var body: some View {
        VStack {
            NavigationStack{
                if showCapturedPhoto {
                    if let image = capturedImage {
                        //display the view
                        CapturedImageView(capturedImage: image)
                    }
                } else {
                    //we need this button for state changes
                    Button("Capture Photo") {
                        showImagePicker = true
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(sourceType: .camera, selectedImage: $capturedImage, didFinishPicking: { image in
                            capturedImage = image
                            showCapturedPhoto = true
                        })
                    }
                    .onAppear {
                        //Simulate tap on the button to open the camera picker
                        showImagePicker = true
                    }
                    .hidden() //hide the button from users
                }
            }
            
        }
        .ignoresSafeArea()
        .navigationBarTitle("Camera")
        
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    var didFinishPicking: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Update logic if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                parent.didFinishPicking(image)
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // Handle cancel action if needed
        }
    }
}

