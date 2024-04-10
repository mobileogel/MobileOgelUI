//
//  LegoSetViewModelTests.swift
//  MobileOgelTests

import XCTest
@testable import MobileOgelUI

final class LegoSetViewModelTests: XCTestCase {
    
    var viewModel: LegoSetViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = LegoSetViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testTableStatusEmpty() {
        XCTAssertTrue(viewModel.tableStatus())
    }
    
    func testCombineSets() {
        viewModel.perfectSets = [LegoSet(setId: 1, setName: "Set 1", pieceCount: 10, piecesMissing: nil, setUrl: "", matchType: "Perfect")]
        viewModel.fuzzySets = [LegoSet(setId: 2, setName: "Set 2", pieceCount: 20, piecesMissing: nil, setUrl: "", matchType: "Fuzzy")]
        viewModel.combineSets()
        XCTAssertEqual(viewModel.allSets.count, 2)
    }
    
    func testReset() {
        viewModel.reset()
        XCTAssertTrue(viewModel.tableStatus())
    }
}
