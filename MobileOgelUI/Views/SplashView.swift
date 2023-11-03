//
//  SplashView.swift
//  MobileOgel
//
//  Created by Shuvaethy Neill on 2023-11-01.
//

import SwiftUI

struct SplashView: View {
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if self.isActive {
                MainView()
            } else {
                Color.white.edgesIgnoringSafeArea(.all)
                Image("mobile_ogel_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 300)
            }
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                // could do animation here
                self.isActive = true
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
