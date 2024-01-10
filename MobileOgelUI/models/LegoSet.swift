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
    var setName: String
    var pieceCount: Int
    var piecesMissing: [LegoPiece]?
    
    //these two functions are apparently needed to fix "not conforming to Type Hashable and Equatable error, because of "missingPieces" var
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: LegoSet, rhs: LegoSet) -> Bool {
        return lhs.id == rhs.id
    }
}
