//
//  SplashView.swift
//  MobileOgel
//
//  Created by Shuvaethy Neill on 2023-11-01.
//

import SwiftUI

struct SplashView: View {
    @State var isActive: Bool = false
    @State private var cameraViewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            if self.isActive {
                MainView()
                    .environment(cameraViewModel)
                //HomeView()
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
            Task{
                let t = await connectDbAndFetchAll()
                print(t as Any)
            }
                
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
