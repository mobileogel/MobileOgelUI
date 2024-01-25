//
//  ClassToNameMap.swift
//  MobileOgelUI
//
//  Created by Guy Morgenshtern on 2024-01-18.
//

class ClassToNameMap {
    static let labelMapping: [String: String] = [
        "TIRE": "TIRE",
        "X1-Y1-Z1-EYE": "1 by 1 by 1 Eye Block",
        "X1-Y1-Z1-EYE-CLOSED": "1 by 1 by 1 Eye Closed",
        "X1-Y1-Z1-EYE-OPEN": "1 by 1 by 1 Eye Open",
        "X1-Y1-Z1-FLAT": "1 by 1 by 1 Flat Block",
        "X1-Y1-Z1-TRIANGLE": "1 by 1 by 1 Triangle Block",
        "X1-Y1-Z2": "1 by 1 by 2 Block",
        "X1-Y1-Z2-CIRCLE": "1 by 1 by 2 Circle Block",
        "X1-Y1-Z2-STUDDED": "1 by 1 by 2 Studded Block",
        "X1-Y1-Z3-STUDDED": "1 by 1 by 3 Studded Block",
        "X1-Y2-Z1": "1 by 2 by 1 Block",
        "X1-Y2-Z1-TRIANGLE": "1 by 2 by 1 Triangle Block",
        "X1-Y2-Z2": "1 by 2 by 2 Block",
        "X1-Y2-Z2-CHAMFER": "1 by 2 by 2 Chamfer Block",
        "X1-Y2-Z2-FILLET": "1 by 2 by 2 Fillet Block",
        "X1-Y2-Z2-HOLE": "1 by 2 by 2 Hole Block",
        "X1-Y2-Z2-STUDDED": "1 by 2 by 2 Studded Block",
        "X1-Y2-Z2-TRIANGLE": "1 by 2 by 2 Triangle Block",
        "X1-Y2-Z2-TWINFILLET": "1 by 2 by 2 Twinfillet Block",
        "X1-Y2-Z3": "1 by 2 by 3 Block",
        "X1-Y2B-Z2": "X1-Y2B-Z2", // Doesn't follow the specified format
        "X1-Y3-Z2": "1 by 3 by 2 Block",
        "X1-Y3-Z2-FILLET": "1 by 3 by 2 Fillet Block",
        "X1-Y4-Z1": "1 by 4 by 1 Block",
        "X1-Y4-Z2": "1 by 4 by 2 Block",
        "X1-Y4-Z2-ARCH": "1 by 4 by 2 Arch Block",
        "X1-Y4-Z2-STUDDED": "1 by 4 by 2 Studded Block",
        "X1-Y4-Z3-ARCH": "1 by 4 by 3 Arch Block",
        "X1-Y6-Z2": "1 by 6 by 2 Block",
        "X2-Y2-Z1": "2 by 2 by 1 Block",
        "X2-Y2-Z2": "2 by 2 by 2 Block",
        "X2-Y2-Z2-AXLE": "2 by 2 by 2 Axle Block",
        "X2-Y2-Z2-CIRCLE": "2 by 2 by 2 Circle Block",
        "X2-Y2-Z2-DOME": "2 by 2 by 2 Dome Block",
        "X2-Y2-Z2-FILLET": "2 by 2 by 2 Fillet Block",
        "X2-Y2-Z2-FILLET-INVERT": "2 by 2 by 2 Fillet Invert Block",
        "X2-Y2-Z2-GEAR": "2 by 2 by 2 Gear Block",
        "X2-Y3-Z1": "2 by 3 by 1 Block",
        "X2-Y3-Z2": "2 by 3 by 2 Block",
        "X2-Y3-Z2-CHAMFER": "2 by 3 by 2 Chamfer Block",
        "X2-Y3-Z2-FILLET-INVERT": "2 by 3 by 2 Fillet Invert Block",
        "X2-Y4-Z2": "2 by 4 by 2 Block",
        "X2-Y6-Z1": "2 by 6 by 1 Block",
        "X2-Y6-Z2": "2 by 6 by 2 Block",
        "X2-Y8-Z1": "2 by 8 by 1 Block",
        "X2-Y8-Z2": "2 by 8 by 2 Block"
    ]


    static func getMappedValue(forKey key: String) -> String {
        if let mappedValue = labelMapping[key] {
            return mappedValue
        } else {
            return "Key not found"
        }
    }
}

