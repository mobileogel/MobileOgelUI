//
//  HomeView.swift
//  MobileOgelUI
//
//  Crontributors: Shuvaethy Neill and Harsimran Kanwar
//

import SwiftUI

struct HomeView: View {
    @State private var cameraViewModel = CameraViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.white
                    .ignoresSafeArea()
                VStack(spacing:20) {
                    
                    Text("Hi!")
                        .font(.title)
                        .foregroundStyle(.black)
                        .bold()
                        .padding(.top, 20)
                    
                    Image("mobile_ogel_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 300)
                        .padding(.top, 60)
                    
                    VStack(spacing:10) {

                        NavButton(destination: MainView().environment(cameraViewModel), title: "Scan Lego", width: 250,cornerRadius: 10)
                            .simultaneousGesture(TapGesture().onEnded{
                                cameraViewModel.loadCamera = true
                            })

                        
                        NavButton(destination: PieceInventoryView(), title: "My Pieces", width: 250, cornerRadius: 10)
                        NavButton(destination: LibraryView(), title: "My Library", width: 250, cornerRadius: 10)
                        Spacer()
                        
                    }

                }
            }
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
