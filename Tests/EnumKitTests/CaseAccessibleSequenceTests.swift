//
//  CaseAccessibleSequenceTests.swift
//  EnumKitTests
//
//  Created by Giuseppe Lanza on 17/08/2019.
//

import XCTest
import EnumKit

class CaseAccessibleSequenceTests: XCTestCase {
    let enumCases = [
        MockEnum.noAssociatedValue,
        MockEnum.anInt(10),
        MockEnum.withNamedPayload(payload: "David"),
        MockEnum.withAnonymousPayload("Freddy"),
        MockEnum.withAnonymousPayload("Mercury"),
        MockEnum.withNamedPayload(payload: "Bowie"),
        MockEnum.anInt(20),
        MockEnum.anInt(30)
    ]

    func testItCanExtractAssociatedValues() {
        let result = enumCases.associatedValues(case: MockEnum.withNamedPayload)
        XCTAssertEqual(result, ["David", "Bowie"])
    }
    
    func testItCanExtractAnonymousAssociatedValues() {
        let result = enumCases.associatedValues(case: MockEnum.withAnonymousPayload)
        XCTAssertEqual(result, ["Freddy", "Mercury"])
    }
    
    func testItCanFailExtractAssociatedValues() {
        let result = enumCases.associatedValues(case: MockEnum.anotherInt)
        XCTAssertEqual(result, [])
    }
    
    func testItCanFilterNoAssociatedValue() {
        let result = enumCases.filter(case: MockEnum.noAssociatedValue)
        XCTAssertEqual(result, [.noAssociatedValue])
    }
    
    func testItCanFailFilterNoAssociatedValue() {
        let result = enumCases.filter(case: MockEnum.anotherWithoutAssociatedValue)
        XCTAssertEqual(result, [])
    }
    
    func testItCanFilterAnonymousAssociatedValue() {
        let result = enumCases.filter(case: MockEnum.withAnonymousPayload)
        XCTAssertEqual(result, [.withAnonymousPayload("Freddy"), .withAnonymousPayload("Mercury")])
    }
    
    func testItCanFailFilterAnonymousAssociatedValue() {
        let result = enumCases.filter(case: MockEnum.anotherInt)
        XCTAssertEqual(result, [])
    }
    
    func testItCanFilterNamedAssociatedValue() {
        let result = enumCases.filter(case: MockEnum.withNamedPayload)
        XCTAssertEqual(result, [.withNamedPayload(payload: "David"), .withNamedPayload(payload: "Bowie")])
    }
    
    func testItCanFailFilterNamedAssociatedValue() {
        let result = enumCases.filter(case: MockEnum.namedInt)
        XCTAssertEqual(result, [])
    }
    
    func testItCanExcludeNoAssociatedValue() {
        let result = enumCases.exclude(case: MockEnum.noAssociatedValue)
        XCTAssertEqual(result, [
            MockEnum.anInt(10),
            MockEnum.withNamedPayload(payload: "David"),
            MockEnum.withAnonymousPayload("Freddy"),
            MockEnum.withAnonymousPayload("Mercury"),
            MockEnum.withNamedPayload(payload: "Bowie"),
            MockEnum.anInt(20),
            MockEnum.anInt(30)
            ])
    }
    
    func testItCanFailExcludeNoAssociatedValue() {
        let result = enumCases.exclude(case: MockEnum.anotherWithoutAssociatedValue)
        XCTAssertEqual(result, enumCases)
    }
    
    func testItCanExcludeAnonymousAssociatedValue() {
        let result = enumCases.exclude(case: MockEnum.withAnonymousPayload)
        XCTAssertEqual(result, [
            MockEnum.noAssociatedValue,
            MockEnum.anInt(10),
            MockEnum.withNamedPayload(payload: "David"),
            MockEnum.withNamedPayload(payload: "Bowie"),
            MockEnum.anInt(20),
            MockEnum.anInt(30)
            ])
    }
    
    func testItCanFailExcludeAnonymousAssociatedValue() {
        let result = enumCases.exclude(case: MockEnum.anotherInt)
        XCTAssertEqual(result, enumCases)
    }
    
    func testItCanExcludeNamedAssociatedValue() {
        let result = enumCases.exclude(case: MockEnum.withNamedPayload)
        XCTAssertEqual(result, [
            MockEnum.noAssociatedValue,
            MockEnum.anInt(10),
            MockEnum.withAnonymousPayload("Freddy"),
            MockEnum.withAnonymousPayload("Mercury"),
            MockEnum.anInt(20),
            MockEnum.anInt(30)
            ])
    }
    
    func testItCanFailExcludeNamedAssociatedValue() {
        let result = enumCases.exclude(case: MockEnum.namedInt)
        XCTAssertEqual(result, enumCases)
    }
    
    func testItCanCompactMap() {
        let result = enumCases.compactMap(case: MockEnum.anInt, String.init)
        XCTAssertEqual(result, ["10", "20", "30"])
    }
    
    func testItCanFailCompactMap() {
        let result = enumCases.compactMap(case: MockEnum.withNamedPayload, Int.init)
        XCTAssertEqual(result, [])
    }
    
    func testItCanFlatMap() {
        let result = enumCases.flatMap(case: MockEnum.withNamedPayload, Array.init)
        XCTAssertEqual(result, ["D", "a", "v", "i", "d", "B", "o", "w", "i", "e"])
    }
    
    func testForeach() {
        var result = ""
        enumCases.forEach(case: MockEnum.withNamedPayload) {
            result += $0
        }
        XCTAssertEqual(result, "DavidBowie")
    }
}
