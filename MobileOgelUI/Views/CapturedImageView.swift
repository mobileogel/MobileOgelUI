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
                        
                        NavButton(destination: PieceInventoryView(), title: "Detect Pieces", width: 200, cornerRadius: 10)
                            .simultaneousGesture(TapGesture().onEnded{
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
                                }})
                    }
                }
            }
        }
        //.ignoresSafeArea() - for now
    }
}
