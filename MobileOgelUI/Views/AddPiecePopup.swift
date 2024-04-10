//
//  AddPiecePopup.swift
//  MobileOgelUI
//
//  Contributors: Shuvaethy Neill and Andre Hazim
//

import SwiftUI

struct AddPiecePopup: View {
    var vm: LegoPieceViewModel
    
    @Binding var showPopup: Bool
    @State private var selectedPieceType: String = "TIRE"
    @State private var selectedColor: LegoColour = .black
    @State private var quantity: Int = 1
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Add Piece")
                    .foregroundColor(.black)
                    .font(.system(size: 24))
                    .bold()
                Spacer()
                Button(action: {
                    showPopup.toggle()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.black)
                        .font(.system(size: 24))
                }
            }
            HStack {
                Text("Name:")
                    .foregroundColor(.black)
                    .bold()
                
                Picker("Piece Type", selection: $selectedPieceType) {
                    ForEach(ClassToNameMap.labelMapping.keys.sorted(), id: \.self) { key in
                        Text(ClassToNameMap.labelMapping[key] ?? "")
                            .tag(key)
                    }
                }
            }
            HStack {
                Text("Colour:")
                    .foregroundColor(.black)
                    .bold()
                
                Picker("Color", selection: $selectedColor) {
                    ForEach(LegoColour.allCases, id: \.self) { color in
                        Text(color.rawValue)
                            .tag(color)
                    }
                }
            }
            
            Stepper("Quantity: \(quantity)", value: $quantity, in: 1...50)
                .foregroundColor(.black)
                .bold()
            
            Button(action: {
                // create LegoPiece object and add it to the VM's legoPieces array
                vm.addNewPiece(imageName: selectedPieceType, pieceName: ClassToNameMap.labelMapping[selectedPieceType] ?? "Unknown", quantity: quantity, colour: selectedColor)
                
                // close the popup
                showPopup.toggle()
            }) {
                Text("Add")
                    .foregroundColor(.white)
                    .bold()
                    .padding(10)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding(EdgeInsets(top: 40, leading: 24, bottom: 40, trailing: 24))
        .background(Color.white.cornerRadius(20))
        .shadowedStyle()
        .padding(.horizontal, 40)
    }
}

extension View {
    
    @ViewBuilder
    func applyIf<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }
    
    func shadowedStyle() -> some View {
        self
            .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
            .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
    }
}
