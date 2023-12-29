//
//  CapturedImageView.swift
//  MobileOgelUI
//
//  Created by Harsimran Kanwar on 2023-12-28.
//

import SwiftUI

struct CapturedImageView: View {
    let capturedImage: UIImage
    
    var body: some View {
        Image(uiImage: capturedImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .navigationBarTitle("Captured Image")
        
        Button("Done") {
            //TODO 
        }
    }
}
