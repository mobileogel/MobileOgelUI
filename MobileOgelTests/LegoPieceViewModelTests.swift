//
//  LegoPieceViewModelTests.swift
//  MobileOgelTests

import XCTest
@testable import MobileOgelUI

final class LegoPieceViewModelTests: XCTestCase {
    
    var viewModel: LegoPieceViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = LegoPieceViewModel()
        viewModel.legoPieces = [
            LegoPiece(imageName: "missing_pieces_icon", pieceName: "Piece1", quantity: 2, officialColour: .brightRed),
            LegoPiece(imageName: "missing_pieces_icon", pieceName: "Piece2", quantity: 1, officialColour: .brightBlue)
        ]
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testGetInventoryPieces() {
        // test when cache is not valid
        viewModel.getInventoryPieces()
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.isCacheValid)
        
        // test when cache is already valid
        viewModel.invalidateCache()
        viewModel.getInventoryPieces()
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.isCacheValid)
    }
    
    func testAddNewPiece() {
        let initialCount = viewModel.getAllPieces().count
        
        // test adding a new piece
        viewModel.addNewPiece(imageName: "imageName", pieceName: "TestPiece", quantity: 1, colour: .brightGreen)
        XCTAssertEqual(viewModel.getAllPieces().count, initialCount + 1)
        
        // test updating quantity of existing piece
        viewModel.addNewPiece(imageName: "imageName", pieceName: "TestPiece", quantity: 2, colour: .brightGreen)
        XCTAssertEqual(viewModel.getAllPieces().count, initialCount + 1)
        XCTAssertEqual(viewModel.getAllPieces().first(where: { $0.pieceName == "TestPiece" && $0.officialColour == .brightGreen })?.quantity, 3)
    }
    
    func testDeletePiece() {
        let initialCount = viewModel.getAllPieces().count
        
        // test deleting a piece
        let pieceToDelete = viewModel.getAllPieces().first
        XCTAssertNotNil(pieceToDelete)
        viewModel.deletePiece(pieceToDelete!)
        XCTAssertEqual(viewModel.getAllPieces().count, initialCount - 1)
    }
    
    func testInvalidateCache() {
        viewModel.invalidateCache()
        XCTAssertFalse(viewModel.isCacheValid)
    }
}
