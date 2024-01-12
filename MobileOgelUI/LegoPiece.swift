//
//  LegoPiece.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill on 2024-01-03.
//

import Foundation

struct LegoPiece: Hashable {
    let id = UUID()
    var imageName: String
    var pieceName: String
    var quantity: Int
}
