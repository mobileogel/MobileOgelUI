//
//  LegoSetFilteringTests.swift
//  MobileOgelTests
//
//  Created by Shuvaethy Neill on 2024-04-09.
//

import XCTest
@testable import MobileOgelUI

final class LegoSetFilteringTests: XCTestCase {
    
    var dbManager: LegoSetDBManager!
    
    override func setUp() {
        super.setUp()
        dbManager = LegoSetDBManager.initializer
    }
    
    override func tearDown() {
        dbManager.dropSetsTable()
        dbManager = nil
        super.tearDown()
    }
    
    func testFindPerfectMatches() async {
        // Mock data for all sets and pieces
        guard let allSets = await dbManager.connectDbAndFetchAll()
        else {
            print("Failed to fetch sets from MongoDB")
            return
        }
        
        let myPieces = LegoPieceAppleMockData.pieces
        
        var sets = dbManager.findPerfectMatches(allSets: allSets, myPieces: myPieces)
        
        XCTAssertEqual(sets.count, 1) // Expecting one perfect match
    }
    
    func testFindFuzzyMatches() async {
        // Mock data for all sets and pieces
        guard let allSets = await dbManager.connectDbAndFetchAll()
        else {
            print("Failed to fetch sets from MongoDB")
            return
        }
        let myPieces: [LegoPiece] = LegoPieceMockData.pieces
        
        var sets = dbManager.findFuzzyMatches(allSets: allSets, myPieces: myPieces)
        
        XCTAssertEqual(sets.count, 5) // Expecting one perfect match
    }
}
