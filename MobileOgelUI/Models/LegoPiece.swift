//
//  LegoPiece.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill
//

import Foundation

struct LegoPiece: Identifiable, Hashable {
    let id = UUID()
    var imageName: String
    var pieceName: String
    var colour: String
    var quantity: Int
}

struct LegoPieceMockData {
    static let pieces = [piece1, piece2, piece3, piece4]
    
    static let piece1 = LegoPiece(imageName: "2x4_black",
                                  pieceName: "Brick 2x4",
                                  colour: "black",
                                  quantity: 4)
    
    static let piece2 = LegoPiece(imageName: "2x4_black",
                                  pieceName: "Brick 2x2",
                                  colour: "black",
                                  quantity: 2)
    
    static let piece3 = LegoPiece(imageName: "2x4_black",
                                  pieceName: "Brick 1x2",
                                  colour: "black",
                                  quantity: 1)
    
    static let piece4 = LegoPiece(imageName: "2x4_black",
                                  pieceName: "Brick 1x4",
                                  colour: "black",
                                  quantity: 3)
}
