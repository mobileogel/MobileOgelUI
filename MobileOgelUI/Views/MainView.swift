//
//  MainView.swift
//  MobileOgel
//
//  Created by Shuvaethy Neill on 2023-11-01.
//

import SwiftUI
import AVFoundation

struct MainView: View {
    @State private var showingInstructions: Bool = true
    //@State private var isShowingCamera = false
    
    var body: some View {
        ZStack {
            CameraPreview()
            
            //Overlay with instructions
            if showingInstructions {
                InstructionsOverlay(okAction: {
                    showingInstructions = false
                    // Show camera when instructions are dismissed
                    //isShowingCamera = true
                })
            }
        }
        .edgesIgnoringSafeArea(.all)
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

//TODO: Implement camera view
struct CameraPreview: View {
    var body: some View {
        Text("Camera Preview Goes Here")
            .foregroundColor(.black)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
