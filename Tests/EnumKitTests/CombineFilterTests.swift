//
//  CaseAccessiblePublisherTests.swift
//  EnumKitTests
//
//  Created by Giuseppe Lanza on 29/09/2019.
//

#if canImport(Combine)
import Combine
#endif

import XCTest
import EnumKit

class CombineFilterTests: XCTestCase {
    #if canImport(Combine)
    
    let events: [CaseAccessible] = [
        MockEnum.withAnonymousPayload("100"),
        MockEnum.withAnonymousPayload("200"),
        MockEnum.withNamedPayload(payload: "100"),
        MockEnum.withAnonymousPayload("400"),
        MockEnum.noAssociatedValue
    ]
    
    func testItCanFilterAnonymousEvents() {
        guard #available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) else { return }

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
        guard #available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) else { return }

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
        guard #available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) else { return }

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
        
    #endif
}
