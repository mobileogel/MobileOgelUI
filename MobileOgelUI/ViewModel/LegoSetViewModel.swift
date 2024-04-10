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
    
    //var perfectSets: [LegoSet] = LegoSetMockData.perfectSampleData
    var perfectSets: [LegoSet] = []
    var fuzzySets: [LegoSet] = []
    var allSets: [LegoSet] = []
    var isLoading = false
    var manager = LegoSetDBManager.initializer
    
    var filterMap: [FilterCategory: [LegoSet]] {
        return [
            .All: allSets,
            .Fuzzy: fuzzySets,
            .Perfect: perfectSets
        ]
    }
    
    func tableStatus() -> Bool{
        var isEmpty = false
        if manager.getLocalTableCount() == 0{
            isEmpty = true
        }
        return isEmpty
    }
    
    func combineSets(){
        allSets += perfectSets
        allSets += fuzzySets
    }
    
    func populateSets(sets: [[String:Any]],myPieces: [LegoPiece]){
        if tableStatus() { //table is empty
            perfectSets = []
            fuzzySets = []
            allSets = []
            //this will find perf matches and store it to the server db
            manager.findPerfectMatches(allSets: sets, myPieces: myPieces)
            manager.findFuzzyMatches(allSets: sets, myPieces: myPieces)
            
        }
        
        let sets = manager.fetchSetsFromLocal()
        perfectSets = sets.0
        fuzzySets = sets.1
        //call combine here for ALL
        combineSets()
        
    }
    
    func reset() {
        manager.dropSetsTable()
        manager.createLocalTable()
    }
}
