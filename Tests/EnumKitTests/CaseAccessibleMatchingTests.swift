//
//  CaseAccessibleMatchingTests.swift
//  EnumKitTests
//
//  Created by Giuseppe Lanza on 13/08/2019.
//

import XCTest

class CaseAccessibleMatchingTests: XCTestCase {
    
    func testItCanMatchNoPayloadCases() {
        let enumCase = MockEnum.noAssociatedValue
        XCTAssert(enumCase.matches(case: MockEnum.noAssociatedValue))
    }
    
    func testItCanFailMatchingNoPayloadCases() {
        let enumCase = MockEnum.noAssociatedValue
        XCTAssertFalse(enumCase.matches(case: MockEnum.anotherWithoutAssociatedValue))
    }
    
    func testItCanMatchCases() {
        let enumCase = MockEnum.withAnonymousPayload("David Bowie")
        XCTAssert(enumCase.matches(case: MockEnum.withAnonymousPayload))
    }
}
