//
//  SplashView.swift
//  MobileOgel
//
//  Contributors: Shuvaethy Neill and Harsimran Kanwar
//

import SwiftUI

struct SplashView: View {
    @State var isActive: Bool = false
    private var cameraViewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            if self.isActive {
                if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
                    MainView()
                        .environmentObject(cameraViewModel)
                }else{
                    HomeView()
                }
                
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
