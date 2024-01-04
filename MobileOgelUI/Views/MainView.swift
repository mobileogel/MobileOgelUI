//
//  MainView.swift
//  MobileOgel
//
//  Contributors: Shuvaethy Neill and Harsimran Kanwar
//

import SwiftUI
import AVFoundation

struct MainView: View {
    //@State private var showingInstructions: Bool = true
    @EnvironmentObject private var cameraViewModel: CameraViewModel
    @State private var isImageSelected = false
    @State private var goHome = false

    var body: some View {
        NavigationStack{
            ZStack {
                if cameraViewModel.isImagePickerPresented {
                    // closure called when use photo button is pressed
                    CameraView(usePhotoNav: {
                        isImageSelected = true
                    })
                    .ignoresSafeArea(.all)
                    .zIndex(1)
                }
                
                // overlay with instructions
                //if cameraViewModel.isShowingInstructions {
                if cameraViewModel.isShowingInstructions {
                    InstructionsOverlay(okAction: {
                        cameraViewModel.isShowingInstructions = false
                        cameraViewModel.isImagePickerPresented = true
                    })
                }else{
                    HomeView()
                }
                
                // display captured image if one is taken
                if isImageSelected {
                    CapturedImageView(capturedImage: cameraViewModel.capturedImage)
                    
                }
            }
            //.edgesIgnoringSafeArea(.all)
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
                    cameraViewModel.isShowingInstructions = true // Show instructions
                    UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                } else {
                    cameraViewModel.isShowingInstructions = false // Don't show instructions
                }
                print(cameraViewModel.isShowingInstructions)
            }
        }
    }
}

struct InstructionsOverlay: View {
    var okAction: () -> Void
    
    var body: some View {
        ZStack {
            // Once we have the camera view working I can make the overlay look better
            Color.black.opacity(0.85)
            
            VStack {
                TitleView()
                Spacer()
                    .frame(height: 60)
                
                VStack(alignment: .leading, spacing: 10) {
                    InstructionText(text: "1. Place your lego pieces in a pile on a flat surface in front of you")
                    InstructionText(text: "2. Take a photo from a birds eye view")
                    InstructionText(text: "3. Discover the sets you can build!")
                }
                .padding()
                
                Spacer()
                    .frame(height: 70)
                
                Button(action: {
                    okAction()
                }) {
                    Text("Get started")
                        .bold()
                        .foregroundColor(.black)
                        .padding(20)
                }
                .background(Color.white)
                .cornerRadius(20)
            }
        }
    }
}

struct TitleView: View {
    var body: some View {
        Text("Ready to build? Le-go!")
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
    }
}

struct InstructionText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.system(size:20))
            .foregroundColor(.blue)
            .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
