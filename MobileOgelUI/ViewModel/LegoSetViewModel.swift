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
    
    //helper function to convert db sets to LegoSets
    func convertToLegoSet(from dict: [String: Any]) -> LegoSet? {
        guard let setId = dict["setId"] as? Int,
              let setName = dict["setName"] as? String,
              let pieceCount = dict["pieceCount"] as? Int,
              let setUrl = dict["setUrl"] as? String else {
            print("Failed to extract required values from dictionary: \(dict)")
            return nil
        }

        return LegoSet(setId: setId,
                       setName: setName,
                       pieceCount: pieceCount,
                       piecesMissing: nil, // Assuming this will be set later
                       setUrl: setUrl)
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
