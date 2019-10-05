//
//  CombineCaptureTests.swift
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

class CombineCaptureTests: XCTestCase {
    
    let events: [CaseAccessible] = [
        MockEnum.withAnonymousPayload("100"),
        MockEnum.withAnonymousPayload("200"),
        MockEnum.withNamedPayload(payload: "100"),
        MockEnum.withAnonymousPayload("400"),
        MockEnum.noAssociatedValue
    ]
    
    func testItCanCaptureAnonymousAssociatedValueEvents() {
        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .capture(case: MockEnum.withAnonymousPayload)
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<String, Never>] = [
            .subscribed,
            .next("100"),
            .next("200"),
            .next("400")
        ]
        
        XCTAssertEqual(recording.events, expected)
    }
    
    func testItCanCaptureNamedAssociatedValueEvents() {
        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .capture(case: MockEnum.withNamedPayload)
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<String, Never>] = [
            .subscribed,
            .next("100")
        ]
        
        XCTAssertEqual(recording.events, expected)
    }

    
    func testItCanCaptureNoAssociatedValueEvents() {
        let publisher = PassthroughSubject<CaseAccessible, Never>()
        let recording = publisher
            .capture(case: MockEnum.noAssociatedValue)
            .map { "noVal" }
            .record()
        
        events.forEach { publisher.send($0) }
        
        let expected: [CombineEvents<String, Never>] = [
            .subscribed,
            .next("noVal")
        ]
        
        XCTAssertEqual(recording.events, expected)
    }
}
