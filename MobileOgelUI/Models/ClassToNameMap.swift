//
//  ClassToNameMap.swift
//  MobileOgelUI
//
//  Created by Guy Morgenshtern on 2024-01-18.
//

class ClassToNameMap {
    static let labelMapping: [String: String] = [
        "TIRE": "TIRE",
        "X1-Y1-Z1-EYE": "1x1x1 Eye Block",
        "X1-Y1-Z1-EYE-CLOSED": "1x1x1 Eye Closed",
        "X1-Y1-Z1-EYE-OPEN": "1x1x1 Eye Open",
        "X1-Y1-Z1-FLAT": "1x1x1 Flat Block",
        "X1-Y1-Z1-TRIANGLE": "1x1x1 Triangle Block",
        "X1-Y1-Z2": "1x1x2 Block",
        "X1-Y1-Z2-CIRCLE": "1x1x2 Circle Block",
        "X1-Y1-Z2-STUDDED": "1x1x2 Studded Block",
        "X1-Y1-Z3-STUDDED": "1x1x3 Studded Block",
        "X1-Y2-Z1": "1x2x1 Block",
        "X1-Y2-Z1-TRIANGLE": "1x2x1 Triangle Block",
        "X1-Y2-Z2": "1x2x2 Block",
        "X1-Y2-Z2-CHAMFER": "1x2x2 Chamfer Block",
        "X1-Y2-Z2-FILLET": "1x2x2 Fillet Block",
        "X1-Y2-Z2-HOLE": "1x2x2 Hole Block",
        "X1-Y2-Z2-STUDDED": "1x2x2 Studded Block",
        "X1-Y2-Z2-TRIANGLE": "1x2x2 Triangle Block",
        "X1-Y2-Z2-TWINFILLET": "1x2x2 Twinfillet Block",
        "X1-Y2-Z3": "1x2x3 Block",
        "X1-Y2B-Z2": "X1-Y2B-Z2", // Doesn't follow the specified format
        "X1-Y3-Z2": "1x3x2 Block",
        "X1-Y3-Z2-FILLET": "1x3x2 Fillet Block",
        "X1-Y4-Z1": "1x4x1 Block",
        "X1-Y4-Z2": "1x4x2 Block",
        "X1-Y4-Z2-ARCH": "1x4x2 Arch Block",
        "X1-Y4-Z2-STUDDED": "1x4x2 Studded Block",
        "X1-Y4-Z3-ARCH": "1x4x3 Arch Block",
        "X1-Y6-Z2": "1x6x2 Block",
        "X2-Y2-Z1": "2x2x1 Block",
        "X2-Y2-Z2": "2x2x2 Block",
        "X2-Y2-Z2-AXLE": "2x2x2 Axle Block",
        "X2-Y2-Z2-CIRCLE": "2x2x2 Circle Block",
        "X2-Y2-Z2-DOME": "2x2x2 Dome Block",
        "X2-Y2-Z2-FILLET": "2x2x2 Fillet Block",
        "X2-Y2-Z2-FILLET-INVERT": "2x2x2 Fillet Invert Block",
        "X2-Y2-Z2-GEAR": "2x2x2 Gear Block",
        "X2-Y3-Z1": "2x3x1 Block",
        "X2-Y3-Z2": "2x3x2 Block",
        "X2-Y3-Z2-CHAMFER": "2x3x2 Chamfer Block",
        "X2-Y3-Z2-FILLET-INVERT": "2x3x2 Fillet Invert Block",
        "X2-Y4-Z2": "2x4x2 Block",
        "X2-Y6-Z1": "2x6x1 Block",
        "X2-Y6-Z2": "2x6x2 Block",
        "X2-Y8-Z1": "2x8x1 Block",
        "X2-Y8-Z2": "2x8x2 Block"


    ]


    static func getMappedValue(forKey key: String) -> String {
        if let mappedValue = labelMapping[key] {
            return mappedValue
        } else {
            return "Key not found"
        }
    }
}

