//
//  CapturedImageView.swift
//  MobileOgelUI
//
//  Contributors: Shuvaethy Neill and Harsimran Kanwar
//

import SwiftUI

struct CapturedImageView: View {
    var cameraViewModel: CameraViewModel
    var legoPieceViewModel: LegoPieceViewModel = LegoPieceViewModel()
    @State private var isProcessing = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.white // need some background color here to separate pages
                if isProcessing {
                    LoaderView()
                } else {
                    VStack(spacing: 20) {
                        
                        Text("Captured Image")
                            .font(.largeTitle)
                            .foregroundStyle(.black)
                            .bold()
                            .padding(.top, 20)
                        
                        // display image based on screen size
                        GeometryReader { geometry in
                            Image(uiImage: UIImage(named: "sample_image")!)
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: max(geometry.size.width - 40, 0),
                                    height: max(geometry.size.height - 40, 0)
                                )
                                .padding(20)
                        }
                        
                        NavButton(destination: PieceInventoryView().environment(legoPieceViewModel), title: "Detect Pieces", width: 200, cornerRadius: 10)
                            .simultaneousGesture(TapGesture().onEnded {
                                isProcessing = true
                                print("detect pieces button tapped")
                                
                                // perform the processing asynchronously
                                DispatchQueue.global().async {
                                    legoPieceViewModel.legoPieces = cameraViewModel.processCapturedImage()
                                    // update the UI on the main thread
                                    DispatchQueue.main.async {
                                        isProcessing = false
                                        
                                        // later - navigate to PieceInventoryView here if needed
                                    }
                                }
                            })
                            .padding(.bottom, 20)
                    }
                }
            }
        }
        //.ignoresSafeArea() - for now
    }
}
