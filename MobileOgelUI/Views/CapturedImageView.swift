//
//  CapturedImageView.swift
//  MobileOgelUI
//
//  Contributors: Shuvaethy Neill and Harsimran Kanwar
//

import SwiftUI

struct CapturedImageView: View {
    var capturedImage: UIImage?
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.white // need some background color here to separate pages
                VStack{
                    Text("Captured Image")
                        .font(.largeTitle)
                        .bold()
                    
                    if let image = capturedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 600)
                            .padding(20)
                    }
                    
                    // TODO: have to change to show loader and send image to model
                    NavButton(destination: PieceInventoryView(), title: "Detect pieces", width: 200, cornerRadius: 10)
                    
                }
            }
        }
    }
}
