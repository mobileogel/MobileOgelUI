//
//  CapturedImageView.swift
//  MobileOgelUI
//
//  Contributors: Shuvaethy Neill and Harsimran Kanwar
//

import SwiftUI

struct CapturedImageView: View {
    var viewModel: CapturedImageViewModel
    var legoPieceViewModel: LegoPieceViewModel
    @State var isReadyToNav = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.white // need some background color here to separate pages
                if viewModel.isProcessing {
                    LoaderView()
                } else {
                    VStack(spacing: 20) {
                        
                        Text("Captured Image")
                            .font(.largeTitle)
                            .foregroundStyle(.black)
                            .bold()
                            .padding(.top, 20)
                        
                        // display image based on screen size
                        GeometryReader { geometry in
                            Image(uiImage: viewModel.capturedImage!)
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: max(geometry.size.width - 40, 0),
                                    height: max(geometry.size.height - 40, 0)
                                )
                                .padding(20)
                        }
                        
                        Button{
                            print("Detect pieces button tapped")
                            viewModel.processCapturedImage {
                                legoPieceViewModel.invalidateCache()
                                isReadyToNav = true
                                print("\nwe ready to nav\n")
                            }
                        } label: {
                            {
                                Text("Detect pieces")
                                    .modifier(ButtonTextModifier(width: 200))
                            }()
                                .modifier(ButtonModifier(cornerRadius: 10))
                            .padding(20)
                        }
                        .navigationDestination(isPresented: $isReadyToNav){
                            PieceInventoryView()
                                .navigationBarBackButtonHidden(true)
                            
                        }
                    }
                }
            }
        }
        //.ignoresSafeArea() - for now
    }
}
