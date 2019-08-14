//
//  CaseAccessibleLabelsTests.swift
//  EnumKitTests
//
//  Created by Giuseppe Lanza on 13/08/2019.
//

import XCTest
@testable import EnumKit

class CaseAccessibleLabelsTests: XCTestCase {
    
    func testLabelsForCasesWithNoPayloads() {
        let enumCase = MockEnum.noAssociatedValue
        XCTAssertEqual(enumCase.label, "noAssociatedValue")
    }
    
    func testLabelsForCasesWithPayloads() {
        let enumCase = MockEnum.withNamedPayload(payload: "David Bowie")
        XCTAssertEqual(enumCase.label, "withNamedPayload")
    }
    
    func testLabelsForCasesWithAnonymousPayloads() {
        let enumCase = MockEnum.withAnonymousPayload("David Bowie")
        XCTAssertEqual(enumCase.label, "withAnonymousPayload")
    }
}
