//
//  CaseAccessibleMatchingTests.swift
//  EnumKitTests
//
//  Created by Giuseppe Lanza on 13/08/2019.
//

import XCTest
import EnumKit

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
    
    func testItCanFailMatchCases() {
        let enumCase = MockEnum.withAnonymousPayload("David Bowie")
        XCTAssertFalse(enumCase.matches(case: MockEnum.withNamedPayload))
    }
    
    func testItCanMatchNoPayloadCasesWithOperator() {
        let enumCase = MockEnum.noAssociatedValue
        XCTAssert(enumCase ~= MockEnum.noAssociatedValue)
    }
    
    func testItCanFailMatchingNoPayloadCasesWithOperator() {
        let enumCase = MockEnum.noAssociatedValue
        XCTAssertFalse(enumCase ~= MockEnum.anotherWithoutAssociatedValue)
    }
    
    func testItCanMatchCasesWithOperator() {
        let enumCase = MockEnum.withAnonymousPayload("David Bowie")
        XCTAssert(enumCase ~= MockEnum.withAnonymousPayload)
    }
    
    func testItCanFailMatchCasesWithOperator() {
        let enumCase = MockEnum.withAnonymousPayload("David Bowie")
        XCTAssertFalse(enumCase ~= MockEnum.withNamedPayload)
    }
    
    func testItCanDoNegativeMatchNoPayloadCases() {
        let enumCase = MockEnum.noAssociatedValue
        XCTAssert(enumCase !~= MockEnum.anotherWithoutAssociatedValue)
    }
    
    func testItCanFailNegativeMatchNoPayloadCases() {
        let enumCase = MockEnum.noAssociatedValue
        XCTAssertFalse(enumCase !~= MockEnum.noAssociatedValue)
    }
    
    func testItCanDoNegativeMatchCases() {
        let enumCase = MockEnum.withAnonymousPayload("David Bowie")
        XCTAssert(enumCase !~= MockEnum.withNamedPayload)
    }
    
    func testItCanFailNegativeMatchCases() {
        let enumCase = MockEnum.withAnonymousPayload("David Bowie")
        XCTAssertFalse(enumCase !~= MockEnum.withAnonymousPayload)
    }

}
