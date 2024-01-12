//
//  PieceInventoryView.swift
//  MobileOgel
//
//  Contributors: Shuvaethy Neill, and Guy Morgenshtern
//

import SwiftUI

struct PieceInventoryView: View {
    @StateObject private var viewModel = LegoPieceViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HeaderView(title: "My Pieces")
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.legoPieces, id: \.id) { piece in
                            PieceTileView(piece: piece)
                        }
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

