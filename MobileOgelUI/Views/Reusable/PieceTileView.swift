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
    
    @State var editedQuantity: Int
    
    init(piece: LegoPiece, isEditMode: Bool? = nil, showPopup: Bool? = nil, onDelete: (() -> Void)? = nil) {
        self.piece = piece
        self.isEditMode = isEditMode
        self.showPopup = showPopup
        self.onDelete = onDelete
        self._editedQuantity = State(initialValue: piece.quantity)
    }
    
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
                    Text("Quantity: \(editedQuantity)")
                        .foregroundStyle(.black)
                    Text("Colour: \(piece.officialColour.rawValue)")
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                if let isEditMode = isEditMode, isEditMode {
                    VStack {
                        HStack {
                            Stepper(value: $editedQuantity, in: 0...50) {
                                Text("\(editedQuantity)")
                                    .foregroundStyle(.black)
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
                    }
                }
            }
            .modifier(TileViewModifier())
        }
    }
}
