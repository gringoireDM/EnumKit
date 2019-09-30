//
//  CombineExcludeTests.swift
//  EnumKitTests
//
//  Created by Giuseppe Lanza on 29/09/2019.
//

#if canImport(Combine)
import Combine
#endif

import XCTest
import EnumKit

class CombineExcludeTests: XCTestCase {
    #if canImport(Combine)
    
    let events: [CaseAccessible] = [
        MockEnum.noAssociatedValue,
        MockEnum.noAssociatedValue,
        MockEnum.withNamedPayload(payload: "100"),
        MockEnum.withAnonymousPayload("400"),
        MockEnum.noAssociatedValue
    ]
    
    func testItCanExcludeNoAssociatedValueEvents() {
        guard #available(iOS 13.0, *) else { return }
        
        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .exclude(case: MockEnum.noAssociatedValue)
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<MockEnum, Never>] = [
            .subscribed,
            .next(.withNamedPayload(payload: "100")),
            .next(.withAnonymousPayload("400"))
        ]
        
        XCTAssertEqual(recording.events, expected)
    }
    
    func testItCanExcludeEventsWithAnonymousAssociatedValue() {
        guard #available(iOS 13.0, *) else { return }
        
        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .exclude(case: MockEnum.withAnonymousPayload)
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<MockEnum, Never>] = [
            .subscribed,
            .next(.noAssociatedValue),
            .next(.noAssociatedValue),
            .next(.withNamedPayload(payload: "100")),
            .next(.noAssociatedValue)
        ]
        
        XCTAssertEqual(recording.events, expected)
    }

    
    func testItCanExcludeEventsWithNamedAssociatedValue() {
        guard #available(iOS 13.0, *) else { return }
        
        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .exclude(case: MockEnum.withNamedPayload)
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<MockEnum, Never>] = [
            .subscribed,
            .next(.noAssociatedValue),
            .next(.noAssociatedValue),
            .next(.withAnonymousPayload("400")),
            .next(.noAssociatedValue)
        ]
        
        XCTAssertEqual(recording.events, expected)
    }
        
    #endif
}
