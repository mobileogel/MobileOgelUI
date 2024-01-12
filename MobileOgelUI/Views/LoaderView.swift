//
//  LoaderView.swift
//  MobileOgelUI
//
//  Created by Harsimran Kanwar on 2024-01-12.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                .scaleEffect(2)
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
        }
    }
}

#Preview {
    LoaderView()
}
