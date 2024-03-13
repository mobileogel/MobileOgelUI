//
//  PieceInventoryView.swift
//  MobileOgel
//
//  Contributors: Shuvaethy Neill and Guy Morgenshtern
//

import SwiftUI

struct PieceInventoryView: View {
    @Environment(LegoPieceViewModel.self) private var viewModel
    @State private var isEditMode = false
    @State private var showPopup = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    HeaderView(title: "My Pieces")
                    
                    if viewModel.isLoading {
                        LoaderView()
                    } else {
                        if viewModel.getAllPieces().isEmpty {
                            Spacer()
                            Text("Nothing here! Please scan your pieces to start.")
                                .foregroundStyle(Color.gray)
                            Spacer()
                        } else {
                            HStack {
                                if isEditMode {
                                    ActionButton(title: "Add Piece", buttonColour: Color.green, action: {
                                        showPopup.toggle()
                                    })
                                    .disabled(showPopup)
                                    .padding(EdgeInsets(top: 20, leading: 30, bottom: 0, trailing: 0))
                                }
                                
                                Spacer()
                                
                                ActionButton(title: isEditMode ? "Done" : "Edit", buttonColour: Color.blue, action: {
                                    isEditMode.toggle()
                                })
                                .disabled(showPopup)
                                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 30))
                            }
                            
                            ScrollView {
                                LazyVStack(spacing: 20) {
                                    ForEach(viewModel.getAllPieces(), id: \.id) { piece in
                                        PieceTileView(piece: piece, isEditMode: isEditMode, showPopup: showPopup, onDelete: {
                                            // delete action
                                            viewModel.deletePiece(piece)
                                        })
                                    }
                                }
                                .padding(5)
                            }
                            .padding(20)
                            
                            NavButton(destination: LibraryView(), title:"See Build Options" , width: 200, cornerRadius: 25)
                                .disabled(isEditMode)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.89, green: 0.937, blue: 1.0))
                .onAppear {
                    // retrieve and update Lego pieces when the view appears
                    viewModel.getInventoryPieces()
                }
            }
            if showPopup {
                AddPiecePopup(vm: viewModel, showPopup: $showPopup)
                    .zIndex(1) // place above navstack if i understand hierarchy correctly
            }
        }
    }
}

struct ActionButton: View {
    let title: String
    let buttonColour: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(10)
                .background(buttonColour)
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PieceInventoryView_Previews: PreviewProvider {
    static var previews: some View {
        PieceInventoryView()
    }
}
