//
//  LegoPieceViewModel.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill on 2024-01-11.
//

import Foundation
import Observation

@Observable class LegoPieceViewModel {
    private var legoPieces: [LegoPiece] = []
    var isLoading = false
    private var isCacheValid = false
    
    init() {
    }
    
    func getInventoryPieces() {
        isLoading = true
        
        if !isCacheValid {
            legoPieces = LegoPieceDBManager.shared.getAllPieces()
            isCacheValid = true;
        }
        
        isLoading = false
    }
    
    func getAllPieces() -> [LegoPiece] {
        return legoPieces
    }
    
    func addNewPiece(imageName: String, pieceName: String, quantity: Int, color: LegoColour) {
        //TODO: check if image name exists.. for now since there is no standard to the image names added we will use the missing icon
        let newPiece = LegoPiece(imageName: "missing_pieces_icon", pieceName: pieceName, quantity: quantity, officialColour: color)
        legoPieces.append(newPiece)
        LegoPieceDBManager.shared.addPiece(piece: newPiece)
    }
    
    func deletePiece(_ piece: LegoPiece) {
        legoPieces.removeAll { $0.id == piece.id }
        LegoPieceDBManager.shared.deletePiece(name: piece.pieceName)
    }
    
    func invalidateCache() {
        isCacheValid = false
    }
}
