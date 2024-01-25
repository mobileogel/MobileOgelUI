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
    private var legoPieces: [LegoPiece] = []
    //private var legoPieces: [LegoPiece] = LegoPieceMockData.pieces
    var isLoading = false
    
    init() {
    }
    
    func getInventoryPieces() {
        isLoading = true
        
        let piecesFromDatabase = LegoPieceDBManager.shared.getAllPieces()
        
        // update existing pieces or add new ones
        for databasePiece in piecesFromDatabase {
            if let index = legoPieces.firstIndex(where: { $0.id == databasePiece.id }) {
                legoPieces[index] = databasePiece
            } else {
                legoPieces.append(databasePiece)
            }
        }
        
        isLoading = false
    }
    
    func getAllPieces() -> [LegoPiece] {
        return legoPieces
    }
}
