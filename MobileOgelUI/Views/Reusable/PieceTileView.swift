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
        VStack{ // Added VStack to allow for vertical expansion
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
                    VStack {
                        HStack {
                            Stepper(value: $piece.quantity, in: 0...Int.max, label: {
                                Text("Quantity: \(piece.quantity)")
                                    .foregroundStyle(.black)
                            })
                        }
                        
                        Button(action: {
                            onDelete?() // call onDelete closure when button is clicked
                        }) {
                            Image(systemName: "trash") // Reverted to display the trash icon
                                .font(.system(size: 24))
                                .bold()
                                .foregroundColor(.red)
                        }
                        .disabled(showPopup!)
                    }
                } else {
                    VStack(alignment: .leading) {
                        Text(piece.pieceName)
                            .foregroundStyle(.black)
                            .font(.headline)
                        Text("Quantity: \(piece.quantity)")
                            .foregroundStyle(.black)
                        Text("Colour: \(piece.officialColour.rawValue)")
                            .foregroundStyle(.black)
                    }
                }.modifier(TileViewModifier())
        }
    }
}
