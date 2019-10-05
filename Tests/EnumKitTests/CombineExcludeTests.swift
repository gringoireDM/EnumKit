//
//  CombineExcludeTests.swift
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

class CombineExcludeTests: XCTestCase {
    
    let events: [CaseAccessible] = [
        MockEnum.noAssociatedValue,
        MockEnum.noAssociatedValue,
        MockEnum.withNamedPayload(payload: "100"),
        MockEnum.withAnonymousPayload("400"),
        MockEnum.noAssociatedValue
    ]
    
    func testItCanExcludeNoAssociatedValueEvents() {
        guard #available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) else { return }
        
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

}
