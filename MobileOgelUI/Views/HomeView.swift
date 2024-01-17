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
                    Text("HOME")
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                        .bold()
                        .padding(.top, 40)
                    
                    Spacer()
                    
                    NavButton(destination: MainView().environment(cameraViewModel), title: "Scan", width: 300,cornerRadius: 10)
                        .simultaneousGesture(TapGesture().onEnded{
                            cameraViewModel.loadCamera = true
                        })
                    
                    NavButton(destination: PieceInventoryView(), title: "My Pieces", width: 300, cornerRadius: 10)
                    NavButton(destination: LibraryView(), title: "Library", width: 300, cornerRadius: 10)
                    
                    Spacer()
                        .frame(height: 40)
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
