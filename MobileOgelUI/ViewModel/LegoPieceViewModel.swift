//
//  LegoPieceViewModel.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill on 2024-01-11.
//

import Foundation
import Observation

@Observable class LegoPieceViewModel {
    // once we have the call setup
    //var legoPieces: [LegoPiece] = []
    var legoPieces: [LegoPiece] = LegoPieceMockData.pieces
    var isLoading = false
    
    init() {
        // get data and set to legoPieces array
    }
    
    func getInventoryPieces() {
        isLoading = true
        
        // TODO: invoke function in manager to retrieve data and populate legoPieces array
    }
}
