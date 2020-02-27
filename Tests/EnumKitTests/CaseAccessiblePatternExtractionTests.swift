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
    
    func testItCanExtractZeroSizedPayloads() {
        let expected = ZeroSized()
        let enumCase = MockEnum.zeroSized(expected)
        XCTAssertEqual(enumCase.associatedValue(matching: MockEnum.zeroSized), expected)
    }
    
    func testItCanExtractZeroSizedPayloadsThroughSubscript() {
        let expected = ZeroSized()
        let enumCase = MockEnum.zeroSized(expected)
        XCTAssertEqual(enumCase[case: MockEnum.zeroSized], expected)
    }
    
    func testItCanExtractPayloadOverloadingCases() {
        let enumCase = MockEnum.overloading(24)
        XCTAssertEqual(enumCase.associatedValue(matching: { MockEnum.overloading($0) }), 24)
    }
    
    func testItCanExtractPayloadNamedOverloadingCases() {
        let enumCase = MockEnum.overloading(anInt: 24)
        XCTAssertEqual(enumCase.associatedValue(matching: MockEnum.overloading(anInt:)), 24)
    }
    
    func testItCanFailExtractPayloadOverloadingCases() {
        let enumCase = MockEnum.overloading(24)
        XCTAssertNil(enumCase.associatedValue(matching: MockEnum.overloading(anInt:)))
    }
    
    func testItCanFailExtractPayloadNamedOverloadingCases() {
        let enumCase = MockEnum.overloading(anInt: 24)
        XCTAssertNil(enumCase.associatedValue(matching: { MockEnum.overloading($0) }))
    }
    
    func testItCanExtractNamedPayloadsOverloadingCasesWithTuple() {
        let enumCase = MockEnum.overloading(anInt: 24, andString: "aaa")
        let pair = enumCase.associatedValue(matching: MockEnum.overloading(anInt:andString:))
        XCTAssertEqual(pair?.0, 24)
        XCTAssertEqual(pair?.1, "aaa")
    }
    
    func testItCanFailExtractNamedPayloadsOverloadingCasesWithTuple() {
        let enumCase = MockEnum.overloading(anInt: 24, andString: "aaa")
        XCTAssertNil(enumCase.associatedValue(matching: MockEnum.overloading(anInt:)))
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
