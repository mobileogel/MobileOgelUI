//
//  LegoPiece.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill
//

import Foundation

struct LegoPiece: Identifiable, Hashable, Codable {
    let id = UUID()
    var imageName: String
    var pieceName: String
    var quantity: Int
    var officialColour: LegoColour
}

struct LegoPieceMockData {
    static let pieces = [piece1, piece2, piece3, piece4, piece5, piece6, piece7, piece8, piece9, piece10, piece11, piece12]
    
    static let piece1 = LegoPiece(imageName: "X1-Y2-Z2_coolYellow",
                                  pieceName: "1x2x2 Block",
                                  quantity: 1,
                                  officialColour: .coolYellow)
    
    static let piece2 = LegoPiece(imageName: "X1-Y2-Z2_BrightYellowishGreen",
                                  pieceName: "1x2x2 Block",
                                  quantity: 4,
                                  officialColour: .brightYellowishGreen)
    
    static let piece3 = LegoPiece(imageName: "X2-Y2-Z2-FILLET_mediumLavender",
                                  pieceName: "2x2x2 Fillet Block",
                                  quantity: 2,
                                  officialColour: .mediumLavender)
    
    static let piece4 = LegoPiece(imageName: "X2-Y2-Z2_mediumNougat",
                                  pieceName: "2x2x2 Block",
                                  quantity: 1,
                                  officialColour: .mediumNougat)
    
    static let piece5 = LegoPiece(imageName: "X2-Y2-Z2-FILLET_brightRed",
                                  pieceName: "2x2x2 Fillet Block",
                                  quantity: 2,
                                  officialColour: .brightRed)
    
    static let piece6 = LegoPiece(imageName: "X2-Y3-Z2_brightRed",
                                  pieceName: "2x3x2 Block",
                                  quantity: 1,
                                  officialColour: .brightRed)
    
    static let piece7 = LegoPiece(imageName: "X1-Y2-Z2-FILLET_darkGreen",
                                  pieceName: "1x2x2 Fillet Block",
                                  quantity: 1,
                                  officialColour: .darkGreen)
    
    static let piece8 = LegoPiece(imageName: "X2-Y2-Z2_coolYellow",
                                  pieceName: "2x2x2 Block",
                                  quantity: 1,
                                  officialColour: .coolYellow)
    
    static let piece9 = LegoPiece(imageName: "X2-Y2-Z1_brightYellowishGreen",
                                  pieceName: "2x2 Flat Brick",
                                  quantity: 1,
                                  officialColour: .brightYellowishGreen)
    
    static let piece10 = LegoPiece(imageName: "X2-Y6-Z1_brightYellowishGreen",
                                  pieceName: "2x6x1 Block",
                                  quantity: 1,
                                  officialColour: .brightYellowishGreen)
    
    static let piece11 = LegoPiece(imageName: "X2-Y2-Z2-FILLET-INVERT_Bright_Yellowish_Green",
                                  pieceName: "2x2x2 Fillet Invert Block",
                                  quantity: 2,
                                  officialColour: .brightYellowishGreen)
    
    static let piece12 = LegoPiece(imageName: "X2-Y2-Z1_Bright_Yellowish_Green",
                                  pieceName: "2x2x1 Block",
                                  quantity: 1,
                                  officialColour: .brightYellowishGreen)
}

struct LegoPieceAppleMockData {
    static let pieces = [piece1, piece2, piece3, piece4, piece5, piece6]
    
    static let piece1 = LegoPiece(imageName: "X2-Y2-Z1_Bright_Yellowish_Green",
                                  pieceName: "2x2x1 Block",
                                  quantity: 1,
                                  officialColour: .brightYellowishGreen)
    
    static let piece2 = LegoPiece(imageName: "X2-Y2-Z2-FILLET-INVERT_Bright_Yellowish_Green",
                                  pieceName: "2x2x2 Fillet Invert Block",
                                  quantity: 2,
                                  officialColour: .brightYellowishGreen)
    
    static let piece3 = LegoPiece(imageName: "X1-Y2-Z2_Chrome_Gold1",
                                  pieceName: "1x2x2 Block",
                                  quantity: 1,
                                  officialColour: .brightYellowishGreen)
    
    static let piece4 = LegoPiece(imageName: "X2-Y3-Z2_Bright_Red",
                                  pieceName: "2x3x2 Block",
                                  quantity: 1,
                                  officialColour: .brightRed)
    
    static let piece5 = LegoPiece(imageName: "X2-Y2-Z2-Fillet_Bright_Red",
                                  pieceName: "2x2x2 Fillet Block",
                                  quantity: 2,
                                  officialColour: .brightRed)
    
    static let piece6 = LegoPiece(imageName: "X1-Y2-Z2-FILLET_Dark_Green",
                                  pieceName: "1x2x2 Fillet Block",
                                  quantity: 1,
                                  officialColour: .darkGreen)
    
}
