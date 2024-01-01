//
//  CapturedImageView.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill on 2023-12-23.
//

import SwiftUI

struct CapturedImageView: View {
    var capturedImage: UIImage?
    
    var body: some View {
        NavigationStack{
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
