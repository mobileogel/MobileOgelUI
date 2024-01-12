//
//  PieceInventoryView.swift
//  MobileOgel
//
//  Contributors: Shuvaethy Neill, and Guy Morgenshtern
//

import SwiftUI

struct PieceInventoryView: View {
    var body: some View {
        NavigationStack {
            VStack {
                HeaderView(title: "My Pieces")
                
                //TODO: refactor to use list (and iterate to account for each piece struct)
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // for example...
                        PieceTileView(piece: LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4))
                        PieceTileView(piece: LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4))
                        PieceTileView(piece: LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4))
                        PieceTileView(piece: LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4))
                        PieceTileView(piece: LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4))
                        PieceTileView(piece: LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4))
                    }
                    .padding(5)
                }
                .padding(20)
                
                NavButton(destination: LibraryView(), title:"See Build Options" , width: 200, cornerRadius: 25)
                
            }
            .background(Color(red: 0.89, green: 0.937, blue: 1.0))
            
        }
    }
}

struct PieceTileView: View {
    var piece: LegoPiece
    
    var body: some View {
        HStack {
            Image(piece.imageName)
                .resizable()
                .frame(width: 80, height:80)
            
            VStack(alignment: .leading) {
                Text(piece.pieceName)
                    .foregroundStyle(.black)
                    .font(.headline)
                Text("Quantity: \(piece.quantity)")
                    .foregroundStyle(.black)
            }
            
            Spacer()
        }
        .modifier(TileViewModifier())
    }
}


struct HeaderView: View {
    let title: String
    
    var body: some View {
        HStack{
            Text(title)
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.black)
                .padding(.leading)
            Spacer()
            
            NavigationLink(destination: HomeView().navigationBarBackButtonHidden(true)) {
                Image(systemName: "house.fill")
                    .font(.largeTitle)
                    .padding(.trailing)
                    .foregroundColor(.black)
            }
        }
        .padding(.top)
    }
}

struct PieceInventoryView_Previews: PreviewProvider {
    static var previews: some View {
        PieceInventoryView()
    }
}

