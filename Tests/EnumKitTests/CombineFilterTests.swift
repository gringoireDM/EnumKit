//
//  CaseAccessiblePublisherTests.swift
//  EnumKitTests
//
//  Created by Giuseppe Lanza on 29/09/2019.
//

#if canImport(Combine)
import Combine
#else
import OpenCombine
#endif

import XCTest
import EnumKit

class CombineFilterTests: XCTestCase {
    
    let events: [CaseAccessible] = [
        MockEnum.withAnonymousPayload("100"),
        MockEnum.withAnonymousPayload("200"),
        MockEnum.withNamedPayload(payload: "100"),
        MockEnum.withAnonymousPayload("400"),
        MockEnum.noAssociatedValue
    ]
    
    func testItCanFilterAnonymousEvents() {
        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .filter(case: MockEnum.withAnonymousPayload)
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<MockEnum, Never>] = [
            .subscribed,
            .next(.withAnonymousPayload("100")),
            .next(.withAnonymousPayload("200")),
            .next(.withAnonymousPayload("400"))
        ]
        
        XCTAssertEqual(recording.events, expected)
    }
    
    func testItCanFilterNamedEvents() {
        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .filter(case: MockEnum.withNamedPayload)
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<MockEnum, Never>] = [
            .subscribed,
            .next(.withNamedPayload(payload: "100"))
        ]
        
        XCTAssertEqual(recording.events, expected)
    }

    func testItCanFilterNoAssociatedValueEvents() {
        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .filter(case: MockEnum.noAssociatedValue)
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<MockEnum, Never>] = [
            .subscribed,
            .next(.noAssociatedValue)
        ]
        
        XCTAssertEqual(recording.events, expected)
    }
}
