//
//  CombineMapTests.swift
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

class CombineMapTests: XCTestCase {
    
    let events: [CaseAccessible] = [
        MockEnum.withAnonymousPayload("100"),
        MockEnum.withAnonymousPayload("200"),
        MockEnum.withNamedPayload(payload: "100"),
        MockEnum.withAnonymousPayload("400"),
        MockEnum.withAnonymousPayload("David Bowie"),
        MockEnum.noAssociatedValue
    ]
    
    func testItCanMapAnonymousEvents() {
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
    
}
