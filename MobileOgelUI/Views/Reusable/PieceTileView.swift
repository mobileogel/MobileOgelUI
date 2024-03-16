//
//  PieceTileView.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill on 2024-03-13.
//

import SwiftUI

struct PieceTileView: View {
    var piece: LegoPiece
    var isEditMode: Bool?
    var showPopup: Bool?
    var onDelete: (() -> Void)? // closure to handle delete action, optional
    
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
                Text("Colour: \(piece.officialColour.rawValue)")
                    .foregroundStyle(.black)
            }
            
            Spacer()
            
            if let isEditMode = isEditMode, isEditMode {
                Button(action: {
                    onDelete?() // call onDelete closure when button is clicked
                }) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 24))
                        .bold()
                        .foregroundColor(.black)
                }
                .disabled(showPopup!)
            }
        }
        .modifier(TileViewModifier())
    }
}
