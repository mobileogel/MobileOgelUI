//
//  PieceInventoryView.swift
//  MobileOgel
//
//  Created by Shuvaethy Neill on 2023-11-02.
//

import SwiftUI

struct PieceInventoryView: View {
    var body: some View {
        VStack {
            HStack{
                Text("My Pieces")
                    .font(.largeTitle)
                    .bold()
                    .padding(.leading)
                Spacer()
                Image(systemName: "house.fill")
                    .font(.largeTitle)
                    .padding(.trailing)
                    .onTapGesture {
                        // go to home page
                    }
            }
            .padding(.top)
            
            ScrollView {
                LazyVStack() {
                    // for example...
                    PieceTileView(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4)
                    PieceTileView(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4)
                    PieceTileView(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4)
                    PieceTileView(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4)
                    PieceTileView(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4)
                    PieceTileView(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4)
                }
                .padding(.horizontal, 10)
            }
            
            Button(action: {
                // TODO: nav to library page
            }) {
                Text("See build options")
                    .bold()
                    .foregroundColor(.white)
                    .padding(20)
            }
                .background(Color.green)
                .cornerRadius(20)
        }
    }
}

struct PieceTileView: View {
    var imageName: String
    var pieceName: String
    var quantity: Int
    
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .frame(width: 80, height:80)
            
            VStack(alignment: .leading) {
                Text(pieceName)
                    .font(.headline)
                Text("Quantity: \(quantity)")
            }
            
            Spacer()
        }
        .padding()
        .background(Color.blue)
        .cornerRadius(15)
        .shadow(radius: 3)
    }
}

struct PieceInventoryView_Previews: PreviewProvider {
    static var previews: some View {
        PieceInventoryView()
    }
}
