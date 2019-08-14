//
//  CaseAccessibleUpdateTests.swift
//  EnumKitTests
//
//  Created by Giuseppe Lanza on 14/08/2019.
//

import XCTest

class CaseAccessibleUpdateTests: XCTestCase {
    
    func testItCanUpdateAssociatedValues() {
        var enumCase = MockEnum.withAnonymousPayload("David Bowie")
        let expectedValue = "Freddy Mercury"
        enumCase.update(value: expectedValue, matching: MockEnum.withAnonymousPayload)
        XCTAssertEqual(enumCase.associatedValue(), expectedValue)
    }
    
    func testItCanFailUpdateAssociatedValues() {
        var enumCase = MockEnum.withAnonymousPayload("David Bowie")
        enumCase.update(value: 10, matching: MockEnum.anInt)
        XCTAssertNil(enumCase[case: MockEnum.anInt])
        XCTAssertEqual(enumCase.associatedValue(), "David Bowie")
    }
    
    func testItCanUpdateWithSubscript() {
        var enumCase = MockEnum.withAnonymousPayload("David Bowie")
        let expectedValue = "Freddy Mercury"
        enumCase[case: MockEnum.withAnonymousPayload] = expectedValue
        XCTAssertEqual(enumCase.associatedValue(), expectedValue)
    }
    
    func testItCanFailUpdateWithSubscript() {
        var enumCase = MockEnum.withAnonymousPayload("David Bowie")
        enumCase[case: MockEnum.anInt] = 10
        XCTAssertNil(enumCase[case: MockEnum.anInt])
        XCTAssertEqual(enumCase.associatedValue(), "David Bowie")
    }

    func testItCanUpdateUsingDefault() {
        var enumCase = MockEnum.anInt(10)
        enumCase[case: MockEnum.anInt, default: 0] += 1
        XCTAssertEqual(enumCase.associatedValue(), 11)
    }
    
    func testItCanFailUpdateUsingDefault() {
        var enumCase = MockEnum.withAnonymousPayload("David Bowie")
        enumCase[case: MockEnum.anInt, default: 0] += 1
        XCTAssertNil(enumCase[case: MockEnum.anInt])
        XCTAssertEqual(enumCase.associatedValue(), "David Bowie")
    }
    
    func testNoChangeOnNilUpdate() {
        var enumCase = MockEnum.withAnonymousPayload("David Bowie")
        enumCase[case: MockEnum.withAnonymousPayload] = nil
        XCTAssertEqual(enumCase.associatedValue(), "David Bowie")
    }
}
