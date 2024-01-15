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
                            cameraViewModel.isShowingInstructions = false
                            cameraViewModel.isImagePickerPresented = true
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

struct NavButton<Destination: View>: View {
    let destination: Destination
    let title: LocalizedStringResource
    let width: CGFloat
    let cornerRadius: CGFloat
    
    var body: some View {
        NavigationLink(
            destination: destination.navigationBarBackButtonHidden(true),
            label: {
                Text(title)
                    .bold()
                    .foregroundColor(.black)
                    .font(.title3)
                    .padding(EdgeInsets(top: 24, leading: 12, bottom: 24, trailing: 12))
                    .frame(maxWidth: width)
            })
        .background(Color(red: 0.859, green: 0.929, blue: 0.702))
        .cornerRadius(cornerRadius)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
