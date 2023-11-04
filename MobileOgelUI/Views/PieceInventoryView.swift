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
            
            //TODO: refactor to use list (and iterate to account for each piece struct)
            ScrollView {
                LazyVStack(spacing: 20) {
                    // for example...
                    PieceTileView(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4)
                    PieceTileView(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4)
                    PieceTileView(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4)
                    PieceTileView(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4)
                    PieceTileView(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4)
                    PieceTileView(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4)
                }
                .padding(5)
            }
            .padding(20)
            
            Button(action: {
                // TODO: nav to library page
            }) {
                Text("See build options")
                    .bold()
                    .foregroundColor(.black)
                    .padding(20)
            }
            .background(Color(red: 0.859, green: 0.929, blue: 0.702))
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
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        .background(Color(red: 0.89, green: 0.937, blue: 1.0))
        .cornerRadius(15)
        .shadow(radius: 3)
    }
}

struct PieceInventoryView_Previews: PreviewProvider {
    static var previews: some View {
        PieceInventoryView()
    }
}
