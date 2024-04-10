//
//  CapturedImageViewModelTests.swift
//  MobileOgelTests
//

import XCTest
@testable import MobileOgelUI

final class CapturedImageViewModelTests: XCTestCase {
    var viewModel: CapturedImageViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CapturedImageViewModel(capturedImage: UIImage())
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testProcessCapturedImageWhenNil() {
        viewModel = CapturedImageViewModel(capturedImage: nil)
        
        viewModel.processCapturedImage {
            XCTAssertFalse(self.viewModel.isProcessing)
        }
    }
}

