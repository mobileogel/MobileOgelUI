//
//  LegoSet.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill on 2024-01-03.
//

import Foundation

struct LegoSet: Identifiable, Hashable, Equatable {
    let id = UUID()
    var setId: Int
    var setUrl: String
    var setName: String
    var pieceCount: Int
    var piecesMissing: [LegoPiece]?
    
    // Hashable and Equatable conformance with optional requires these
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: LegoSet, rhs: LegoSet) -> Bool {
        return lhs.id == rhs.id
    }
}

struct LegoSetMockData {
    //this is data that should come from an endpoint (not necessarily formated to be an object)
    static let allSampleData: [LegoSet] = [LegoSet(setId: 40570, setUrl: "https://www.lego.com", setName: "Halloween Cat & Mouse", pieceCount: 328), LegoSet(setId: 40570, setUrl: "https://www.lego.com",setName: "Halloween Cat & Mouse", pieceCount: 328, piecesMissing: [LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4), LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 2)]), LegoSet(setId: 40570, setUrl: "https://www.lego.com", setName: "Halloween Cat & Mouse", pieceCount: 328, piecesMissing: [LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 1)])]
    
    static let fuzzySampleData: [LegoSet] = [LegoSet(setId: 40570, setUrl: "https://www.lego.com", setName: "Halloween Cat & Mouse", pieceCount: 328, piecesMissing: [LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4), LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 2)]), LegoSet(setId: 40570, setUrl: "https://www.lego.com", setName: "Halloween Cat & Mouse", pieceCount: 328, piecesMissing: [LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 1)])]
    
    static let perfectSampleData: [LegoSet] = [LegoSet(setId: 40570, setUrl: "https://www.lego.com", setName: "Halloween Cat & Mouse", pieceCount: 328)]
}
