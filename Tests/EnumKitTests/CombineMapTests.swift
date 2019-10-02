//
//  CombineMapTests.swift
//  EnumKitTests
//
//  Created by Giuseppe Lanza on 29/09/2019.
//


#if canImport(Combine)
import Combine
#endif

import XCTest
import EnumKit

class CombineMapTests: XCTestCase {
    #if canImport(Combine)
    
    let events: [CaseAccessible] = [
        MockEnum.withAnonymousPayload("100"),
        MockEnum.withAnonymousPayload("200"),
        MockEnum.withNamedPayload(payload: "100"),
        MockEnum.withAnonymousPayload("400"),
        MockEnum.withAnonymousPayload("David Bowie"),
        MockEnum.noAssociatedValue
    ]
    
    func testItCanMapAnonymousEvents() {
        guard #available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) else { return }

        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .map(case: MockEnum.withAnonymousPayload, Int.init)
            .compactMap { $0 }
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<Int, Never>] = [
            .subscribed,
            .next(100),
            .next(200),
            .next(400)
        ]
        
        XCTAssertEqual(recording.events, expected)
    }
    
    func testItCanMapNamedEvents() {
        guard #available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) else { return }

        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .map(case: MockEnum.withNamedPayload, Int.init)
            .compactMap { $0 }
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<Int, Never>] = [
            .subscribed,
            .next(100)
        ]
        
        XCTAssertEqual(recording.events, expected)
    }

    
    func testItCanMapNoAssociatedValueEvents() {
        guard #available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) else { return }

        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .map(case: MockEnum.noAssociatedValue) { "Frank Sinatra" }
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<String, Never>] = [
            .subscribed,
            .next("Frank Sinatra")
        ]
        
        XCTAssertEqual(recording.events, expected)
    }
    
    func testItCanCompactMapAnonymousEvents() {
        guard #available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) else { return }

        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .compactMap(case: MockEnum.withAnonymousPayload, Int.init)
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<Int, Never>] = [
            .subscribed,
            .next(100),
            .next(200),
            .next(400)
        ]
        
        XCTAssertEqual(recording.events, expected)
    }
    
    func testItCanCompactMapNamedEvents() {
        guard #available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) else { return }

        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .compactMap(case: MockEnum.withNamedPayload, Int.init)
            .compactMap { $0 }
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<Int, Never>] = [
            .subscribed,
            .next(100)
        ]
        
        XCTAssertEqual(recording.events, expected)
    }
    
    func testItCanCompactMapNoAssociatedValueEvents() {
        guard #available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) else { return }

        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .compactMap(case: MockEnum.noAssociatedValue) { "Frank Sinatra" }
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<String, Never>] = [
            .subscribed,
            .next("Frank Sinatra")
        ]
        
        XCTAssertEqual(recording.events, expected)
    }
    
    func testItCanFlatMapAnonymousEvents() {
        guard #available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) else { return }

        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .flatMap(case: MockEnum.withAnonymousPayload) { Just($0) }
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<String, Never>] = [
            .subscribed,
            .next("100"),
            .next("200"),
            .next("400"),
            .next("David Bowie")
        ]
        
        XCTAssertEqual(recording.events, expected)
    }
    
    func testItCanFlatMapNamedEvents() {
        guard #available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) else { return }

        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .flatMap(case: MockEnum.withNamedPayload) { Just($0) }
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<String, Never>] = [
            .subscribed,
            .next("100")
        ]
        
        XCTAssertEqual(recording.events, expected)
    }
    
    func testItCanFlatMapNoAssociatedValueEvents() {
        guard #available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) else { return }

        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .flatMap(case: MockEnum.noAssociatedValue) { Just("Frank Sinatra") }
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<String, Never>] = [
            .subscribed,
            .next("Frank Sinatra")
        ]
        
        XCTAssertEqual(recording.events, expected)
    }
    #endif
}
