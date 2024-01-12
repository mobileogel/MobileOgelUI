//
//  LegoPiece.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill
//

import Foundation

struct LegoPiece: Hashable {
    let id = UUID()
    var imageName: String
    var pieceName: String
    var quantity: Int
}

struct LegoPieceMockData {
    static let pieces = [piece1, piece2, piece3, piece4]
    
    static let piece1 = LegoPiece(imageName: "2x4_black",
                                  pieceName: "Brick 2x4",
                                  quantity: 4)
    
    static let piece2 = LegoPiece(imageName: "2x4_black",
                                  pieceName: "Brick 2x2",
                                  quantity: 2)
    
    static let piece3 = LegoPiece(imageName: "2x4_black",
                                  pieceName: "Brick 1x2",
                                  quantity: 1)
    
    static let piece4 = LegoPiece(imageName: "2x4_black",
                                  pieceName: "Brick 1x4",
                                  quantity: 3)
}
