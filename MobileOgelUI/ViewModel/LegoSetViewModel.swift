//
//  LegoSetViewModel.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill on 2024-01-12.
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
    
    // TODO: invoke function in manager to retrieve data and populate set arrays
    
}
