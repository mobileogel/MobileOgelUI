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
    var matchType: String
    
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
    static let allSampleData: [LegoSet] = [LegoSet(setId: 1, setName: "Apple", pieceCount: 8, setUrl: "https://drive.google.com/file/d/1sjQtH2KMxZfr3F6KUIVQ6aPAZbQ4UeeW/view?usp=sharing", matchType: "Perfect"), LegoSet(setId: 2, setName: "House", pieceCount:13, piecesMissing: [LegoPiece(imageName: "X1-Y2-Z2_Transparent", pieceName: "1x2 Brick", quantity: 2, officialColour: .transparent), LegoPiece(imageName: "X2-Y2-Z2-FILLET_mediumLavender", pieceName: "2x2 Fillet Brick", quantity: 2, officialColour: .mediumLavender)], setUrl: "https://drive.google.com/file/d/1CNiT5Ucsq-kgkMVC5ukQZpGyMBiKbpih/view?usp=sharing", matchType: "Fuzzy")]
//    static let allSampleData: [LegoSet] = []
//    
    static let fuzzySampleData: [LegoSet] = [LegoSet(setId: 2, setName: "House", pieceCount:13, piecesMissing: [LegoPiece(imageName: "2x4_black", pieceName: "1 by 2 by 1 Block", quantity: 2, officialColour: .transparent), LegoPiece(imageName: "2x4_black", pieceName: "2 by 2 by 2 Fillet Block", quantity: 2, officialColour: .mediumLavender)], setUrl: "https://drive.google.com/file/d/1CNiT5Ucsq-kgkMVC5ukQZpGyMBiKbpih/view?usp=sharing", matchType: "Fuzzy")]
//    static let fuzzySampleData: [LegoSet] = []

    
    static let perfectSampleData: [LegoSet] = [LegoSet(setId: 1, setName: "Apple", pieceCount: 8, setUrl: "https://drive.google.com/file/d/1sjQtH2KMxZfr3F6KUIVQ6aPAZbQ4UeeW/view?usp=sharing", matchType: "Perfect")]
//    static let perfectSampleData: [LegoSet] = []
}
