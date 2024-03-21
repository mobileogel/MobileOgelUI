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
    
    func addNewPiece(imageName: String, pieceName: String, quantity: Int, colour: LegoColour) {
        
        // to prevent duplicate pieces showing separatley
        if let existingPieceIndex = legoPieces.firstIndex(where: { $0.pieceName == pieceName && $0.officialColour == colour }) {
            legoPieces[existingPieceIndex].quantity += quantity
            
            LegoPieceDBManager.shared.updatePiece(name: pieceName, newQuantity: quantity)
        } else {
            let storedImage = imageName + "_" + String(describing: colour)
            
            let newPiece = LegoPiece(
                imageName: Util.getImageNameOrPlaceHolder(withX: storedImage),
                pieceName: pieceName,
                quantity: quantity,
                officialColour: colour
            )
            
            legoPieces.append(newPiece)
            LegoPieceDBManager.shared.addPiece(piece: newPiece)
            
        }
    }
    
    func deletePiece(_ piece: LegoPiece) {
        legoPieces.removeAll { $0.id == piece.id }
        LegoPieceDBManager.shared.deletePiece(name: piece.pieceName)
    }
    
    func invalidateCache() {
        isCacheValid = false
    }
}
