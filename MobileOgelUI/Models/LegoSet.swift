//
//  LegoSet.swift
//  MobileOgelUI
//
//  Contributors: Shuvaethy Neill and Harsimran Kanwar
//

import Foundation

struct LegoSet: Identifiable, Hashable, Equatable {
    let id = UUID()
    var setId: Int
    var setName: String
    var pieceCount: Int
    var piecesMissing: [LegoPiece]?
    var setUrl: String
    
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
    static let allSampleData: [LegoSet] = [LegoSet(setId: 40570, setName: "Halloween Cat & Mouse", pieceCount: 328, setUrl: "https://www.lego.com"), LegoSet(setId: 40570, setName: "Halloween Cat & Mouse", pieceCount: 328, piecesMissing: [LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4, officialColour: .blue), LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 2, officialColour: .blue)], setUrl: "https://www.lego.com"), LegoSet(setId: 40570, setName: "Halloween Cat & Mouse", pieceCount: 328, piecesMissing: [LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 1, officialColour: .blue)], setUrl: "https://www.lego.com")]
    
    static let fuzzySampleData: [LegoSet] = [LegoSet(setId: 40570, setName: "Halloween Cat & Mouse", pieceCount: 328, piecesMissing: [LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4, officialColour: .blue), LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 2, officialColour: .blue)], setUrl: "https://www.lego.com"), LegoSet(setId: 40570, setName: "Halloween Cat & Mouse", pieceCount: 328, piecesMissing: [LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 1, officialColour: .blue)], setUrl: "https://www.lego.com")]

    
    static let perfectSampleData: [LegoSet] = [LegoSet(setId: 40570, setName: "Halloween Cat & Mouse", pieceCount: 328, setUrl: "https://www.lego.com")]
    
}
