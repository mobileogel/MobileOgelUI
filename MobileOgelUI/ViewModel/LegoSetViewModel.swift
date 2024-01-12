//
//  LegoSetViewModel.swift
//  MobileOgelUI
//
//  Created by Shuvaethy Neill on 2024-01-12.
//

import Foundation

class LegoSetViewModel : ObservableObject {
    
    @Published var perfectSets: [LegoSet] = LegoSetMockData.perfectSampleData
    @Published var fuzzySets: [LegoSet] = LegoSetMockData.fuzzySampleData
    @Published var allSets: [LegoSet] = LegoSetMockData.allSampleData
    @Published var isLoading = false
    
    // TODO: invoke function in manager to retrieve data and populate set arrays
    
}
