//
//  CaseAccessiblePatternExtractionTests.swift
//  EnumKitTests
//
//  Created by Giuseppe Lanza on 13/08/2019.
//

import XCTest

class CaseAccessiblePatternExtractionTests: XCTestCase {
    func testItCanExtractPayload() {
        let expectedPayload = "David Bowie"
        let enumCase = MockEnum.withAnonymousPayload(expectedPayload)
        XCTAssertEqual(enumCase.associatedValue(matching: MockEnum.withAnonymousPayload), expectedPayload)
    }
    
    func testItCanFailExtractPayload() {
        let enumCase = MockEnum.withAnonymousPayload("David Bowie")
        XCTAssertNil(enumCase.associatedValue(matching: MockEnum.withNamedPayload))
    }
    
    func testItCanExtractPayloadWithNamedCases() {
        let expectedPayload = "David Bowie"
        let enumCase = MockEnum.withNamedPayload(payload: expectedPayload)
        XCTAssertEqual(enumCase.associatedValue(matching: MockEnum.withNamedPayload), expectedPayload)
    }
        
    func testItCanExtractPayloadThroughSubscript() {
        let expectedPayload = "David Bowie"
        let enumCase = MockEnum.withAnonymousPayload(expectedPayload)
        XCTAssertEqual(enumCase[case: MockEnum.withAnonymousPayload], expectedPayload)
    }
    
    func testSubscriptCanReturnDefault() {
        let enumCase = MockEnum.withAnonymousPayload("David Bowie")
        XCTAssertEqual(enumCase[case: MockEnum.anInt, default: 0], 0)
    }
    
    func testItCanMapAssociatedValue() {
        let enumCase = MockEnum.anInt(10)
        XCTAssertEqual(enumCase.map(case: MockEnum.anInt) { "\($0)" }, "10")
    }
    
    func testItCanFailMapAssociatedValue() {
        let enumCase = MockEnum.withAnonymousPayload("David Bowie")
        XCTAssertNil(enumCase.map(case: MockEnum.anInt) { "\($0)" })
    }
    
    func testItCanFlatMapAssociatedValue() {
        let enumCase = MockEnum.withAnonymousPayload("1")
        XCTAssertEqual(enumCase.flatMap(case: MockEnum.withAnonymousPayload) { Int($0) }, 1)
    }
    
    func testItCanFlatMapAssociatedValueToNil() {
        let enumCase = MockEnum.withAnonymousPayload("aaa")
        XCTAssertNil(enumCase.flatMap(case: MockEnum.withAnonymousPayload) { Int($0) })
    }
    
    func testItCanFailFlatMapAssociatedValue() {
        let enumCase = MockEnum.withAnonymousPayload("1")
        XCTAssertNil(enumCase.flatMap(case: MockEnum.anInt) { "\($0)" })
    }
    
    func testItCanDoOnCase() {
        var executed = false
        let enumCase = MockEnum.noAssociatedValue
        let returnedCase = enumCase.do(onCase: .noAssociatedValue) { executed = true }
        XCTAssert(executed)
        XCTAssertEqual(enumCase, returnedCase)
    }
    
    func testItCanDoOnCasePattern() {
        var value: String?
        let expected = "David Bowie"
        let enumCase = MockEnum.withAnonymousPayload(expected)
        let returnedCase = enumCase.do(onCase: MockEnum.withAnonymousPayload) { value = $0 }
        XCTAssertEqual(value, expected)
        XCTAssertEqual(enumCase, returnedCase)
    }
    
    func testItCanFailDoOnCase() {
        var executed = false
        let enumCase = MockEnum.noAssociatedValue
        let returnedCase = enumCase.do(onCase: .anotherWithoutAssociatedValue) { executed = true }
        XCTAssertFalse(executed)
        XCTAssertEqual(enumCase, returnedCase)
    }
    
    func testItCanFailDoOnCasePattern() {
        var value: String?
        let enumCase = MockEnum.withAnonymousPayload("David Bowie")
        let returnedCase = enumCase.do(onCase: MockEnum.withNamedPayload) { value = $0 }
        XCTAssertNil(value)
        XCTAssertEqual(enumCase, returnedCase)
    }
}
