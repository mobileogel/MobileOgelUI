//
//  CapturedImageView.swift
//  MobileOgelUI
//
//  Contributors: Shuvaethy Neill and Harsimran Kanwar
//

import SwiftUI

struct CapturedImageView: View {
    var cameraViewModel: CameraViewModel
    @State private var isProcessing = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.white // need some background color here to separate pages
                if isProcessing {
                    LoaderView()
                } else {
                    VStack{
                        Text("Captured Image")
                            .font(.largeTitle)
                            .foregroundStyle(.black)
                            .bold()
                        
                        if let image = cameraViewModel.capturedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 400, height: 600)
                                .padding(20)
                        }
                        
                        
                        // what we had before - but added tap gesture does not work for some reason
                        /*
                         NavButton(destination: PieceInventoryView(), title: "Detect pieces", width: 200, cornerRadius: 10)
                         .onTapGesture {
                         isProcessing = true
                         print("detect pieces button tapped")
                         cameraViewModel.processCapturedImage()
                         }
                         */
                        
                        Button(action: {
                            isProcessing = true
                            print("detect pieces button tapped")
                            
                            // Perform the processing asynchronously
                            DispatchQueue.global().async {
                                cameraViewModel.processCapturedImage()
                                
                                // Update the UI on the main thread
                                DispatchQueue.main.async {
                                    isProcessing = false
                                    // Navigate to PieceInventoryView here if needed
                                }
                            }
                        }) {
                            Text("Detect pieces")
                                .bold()
                                .foregroundColor(.black)
                                .font(.title3)
                                .padding(EdgeInsets(top: 24, leading: 12, bottom: 24, trailing: 12))
                                .frame(width: 200)
                        }
                        .background(Color(red: 0.859, green: 0.929, blue: 0.702))
                        .cornerRadius(10)
                        .padding(20)
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}
