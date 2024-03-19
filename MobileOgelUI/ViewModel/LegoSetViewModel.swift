//
//  LegoSetViewModel.swift
//  MobileOgelUI
//
//  Contributors: Shuvaethy Neill and Harsimran Kanwar
//

import Foundation
import Observation

@Observable class LegoSetViewModel {
    
    enum FilterCategory: String, CaseIterable {
        case Perfect, Fuzzy, All
    }
    
    var perfectSets: [LegoSet] = LegoSetMockData.perfectSampleData
    var fuzzySets: [LegoSet] = LegoSetMockData.fuzzySampleData
    var allSets: [LegoSet] = LegoSetMockData.allSampleData
    var isLoading = false
    
    var filterMap: [FilterCategory: [LegoSet]] {
        return [
            .All: allSets,
            .Fuzzy: fuzzySets,
            .Perfect: perfectSets
        ]
    }
    
    func perfectMatchingSets(scannedPieces: [LegoPiece]) async -> [LegoSet]{
        perfectSets = await findPerfectMatches(myPieces: scannedPieces)!
        return perfectSets
    }
    
    func combineSets() -> [LegoSet]{
        allSets += perfectSets
        allSets += fuzzySets
        return allSets

    }
    
    // TODO: Fuzzy matches
    
    
    
}
