//
//  LoaderView.swift
//  MobileOgelUI
//
//  Contributors: Harsimran and Shuvaethy
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .tint(Color.gray)
                .scaleEffect(2)
        }
    }
}

#Preview {
    LoaderView()
}
