//
//  CameraViewModelTests.swift
//  MobileOgelTests
//

import XCTest
@testable import MobileOgelUI

final class CameraViewModelTests: XCTestCase {
    
    var viewModel: CameraViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CameraViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testHandleInstructionsFirstLaunch() {
        // simulate first launch
        UserDefaults.standard.removeObject(forKey: "hasLaunchedBefore")
        
        viewModel.handleInstructions()
        
        XCTAssertTrue(viewModel.isShowingInstructions)
        // assert that hasLaunchedBefore is correctly set in UserDefaults
        XCTAssertTrue(UserDefaults.standard.bool(forKey: "hasLaunchedBefore"))
    }
    
    func testHandleInstructionsNotFirstLaunch() {
        // simulate regular launch
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        
        viewModel.handleInstructions()
        XCTAssertFalse(viewModel.isShowingInstructions)
    }
}
