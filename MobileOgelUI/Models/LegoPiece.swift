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
    var officialColour: LegoColour
}

struct LegoPieceMockData {
    static let pieces = [piece1, piece2, piece3, piece4]
    
    static let piece1 = LegoPiece(imageName: "2x4_black",
                                  pieceName: "Brick 2x4",
                                  quantity: 4,
                                  officialColour: .black)
    
    static let piece2 = LegoPiece(imageName: "2x4_black",
                                  pieceName: "Brick 2x2",
                                  quantity: 2,
                                  officialColour: .red)
    
    static let piece3 = LegoPiece(imageName: "2x4_black",
                                  pieceName: "Brick 1x2",
                                  quantity: 1,
                                  officialColour: .blue)
    
    static let piece4 = LegoPiece(imageName: "2x4_black",
                                  pieceName: "Brick 1x4",
                                  quantity: 3,
                                  officialColour: .green)
}
