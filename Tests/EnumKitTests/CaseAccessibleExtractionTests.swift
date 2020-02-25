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
    
    func testItCanExtractZeroSizedPayloads() {
        let expected = ZeroSized()
        let enumCase = MockEnum.zeroSized(expected)
        XCTAssertEqual(enumCase.associatedValue(), expected)
    }
    
    func testItCanExtractPayloadThroughSubscript() {
        let expectedPayload = "David Bowie"
        let enumCase = MockEnum.withAnonymousPayload(expectedPayload)
        XCTAssertEqual(enumCase[expecting: String.self], expectedPayload)
    }
    
    func testItCanFailExtractPayloadThroughSubscript() {
        let enumCase = MockEnum.withAnonymousPayload("David Bowie")
        XCTAssertNotEqual(enumCase[expecting: Int.self], 10)
    }
    
    func testItCannotExtractPayloadThroughSubscript() {
        let enumCase = MockEnum.noAssociatedValue
        XCTAssertNil(enumCase[expecting: String.self])
    }
    
    func testItCanExtractZeroSizedPayloadsThroughSubscript() {
        let expected = ZeroSized()
        let enumCase = MockEnum.zeroSized(expected)
        XCTAssertEqual(enumCase[expecting: ZeroSized.self], expected)
    }
}
