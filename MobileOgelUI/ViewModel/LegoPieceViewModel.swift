//
//  LegoPieceViewModel.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill on 2024-01-11.
//

import Foundation

class LegoPieceViewModel : ObservableObject {
    // once we have the call setup
    //@Published var legoPieces: [LegoPiece] = []
    @Published var legoPieces: [LegoPiece] = LegoPieceMockData.pieces
    @Published var isLoading = false
    
    func getInventoryPieces() {
        isLoading = true
        
        // TODO: invoke function in manager to retrieve data and populate legoPieces array
    }
}
