//
//  CaseAccessibleExtractionTests.swift
//  EnumKitTests
//
//  Created by Giuseppe Lanza on 13/08/2019.
//

import XCTest

class CaseAccessibleExtractionTests: XCTestCase {
    func testItCanExtractPayload() {
        let expectedPayload = "David Bowie"
        let enumCase = MockEnum.withAnonymousPayload(expectedPayload)
        XCTAssertEqual(enumCase.associatedValue(), expectedPayload)
    }
    
    func testItCanFailExtractPayload() {
        let enumCase = MockEnum.withAnonymousPayload("David Bowie")
        XCTAssertNotEqual(enumCase.associatedValue(), 10)
    }
    
    func testItCannotExtractPayload() {
        let enumCase = MockEnum.noAssociatedValue
        XCTAssertNil(enumCase.associatedValue())
    }
}
