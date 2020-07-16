//
//  CaseAccessible.swift
//  EnumKit
//
//  Created by Giuseppe Lanza on 13/08/2019.
//

import Foundation

infix operator !~= : AdditionPrecedence

public protocol CaseAccessible { }
public extension CaseAccessible {
    /// Returns the label of the enum case
    var label: String {
        return Mirror(reflecting: self).children.first?.label ?? String(describing: self)
    }
    
    /// Check if an enum case matches another case
    func matches(case: Self) -> Bool {
        var root = self
        var `case` = `case`
        return memcmp(&root, &`case`, MemoryLayout<Self>.size) == 0 || root.label == `case`.label
    }
    
    /// Check if an enum case matches a specific pattern
    func matches<AssociatedValue>(case pattern: (AssociatedValue) -> Self) -> Bool {
        return associatedValue(matching: pattern) != nil
    }
    
    /// Check if an enum case is not matching another case
    func isNotMatching(case: Self) -> Bool {
        return !matches(case: `case`)
    }
    
    /// Check if an enum case is not matching a specific pattern
    func isNotMatching<AssociatedValue>(case pattern: (AssociatedValue) -> Self) -> Bool {
        return !matches(case: pattern)
    }
    
    /// Check if an enum case matches another case
    static func ~=(case: Self, other: Self) -> Bool {
        return `case`.matches(case: other)
    }

    /// Check if an enum case matches a specific pattern
    static func ~=<AssociatedValue>(case: Self, pattern: (AssociatedValue) -> Self) -> Bool {
        return `case`.matches(case: pattern)
    }

    /// Check if an enum case is not matching another case
    static func !~=(case: Self, other: Self) -> Bool {
        return `case`.isNotMatching(case: other)
    }

    /// Check if an enum case is not matching a specific pattern
    static func !~=<AssociatedValue>(case: Self, pattern: (AssociatedValue) -> Self) -> Bool {
        return `case`.isNotMatching(case: pattern)
    }
        
    /// Extract an associated value of the enum case if it is of the expected type
    func associatedValue<AssociatedValue>() -> AssociatedValue? {
        return decompose(expecting: AssociatedValue.self)?.value
    }
    
    /// Extract the associated value of the enum case if it matches a specific pattern
    func associatedValue<AssociatedValue>(matching pattern: (AssociatedValue) -> Self) -> AssociatedValue? {
        guard let decomposed: ([String?], AssociatedValue) = decompose(expecting: AssociatedValue.self),
            let patternDecomposed: ([String?], AssociatedValue) = pattern(decomposed.1).decompose(expecting: AssociatedValue.self),
            decomposed.0 == patternDecomposed.0 else { return nil }
        return decomposed.1
    }
    
    /// Update the associated value of the enum case, it this matches a specific pattern
    /// - parameter value: The new value to associate as associatedValue of the enum case
    /// - parameter pattern: The pattern to match as condition for the update
    mutating func update<AssociatedValue>(value: AssociatedValue, matching pattern: (AssociatedValue) -> Self) {
        guard associatedValue(matching: pattern) != nil else { return }
        self = pattern(value)
    }
    
    subscript<AssociatedValue>(expecting type: AssociatedValue.Type) -> AssociatedValue? {
        get {
            return associatedValue()
        }
    }
    
    subscript<AssociatedValue>(case pattern: (AssociatedValue) -> Self) -> AssociatedValue? {
        get {
            return associatedValue(matching: pattern)
        } set {
            guard let value = newValue else { return }
            update(value: value, matching: pattern)
        }
    }
    
    subscript<AssociatedValue>(case pattern: (AssociatedValue) -> Self, default value: AssociatedValue) -> AssociatedValue {
        get {
            return associatedValue(matching: pattern) ?? value
        } set {
            update(value: newValue, matching: pattern)
        }
    }
    
    /// Map the associated value of the enum case to another type, if the case match a specific pattern.
    /// - parameter pattern: The pattern to be matched to extract the value to be transformed
    /// - parameter transform: The transformation to be executed on values of cases matching pattern
    /// - returns: The transformed value if the enum case was matching the pattern, or nil.
    func map<AssociatedValue, T>(case pattern: (AssociatedValue) -> Self, _ transform: (AssociatedValue) throws -> T) rethrows -> T? {
        guard let value = associatedValue(matching: pattern) else { return nil }
        return try transform(value)
    }
    
    /// Map the associated value of the enum case to another type, if the case match a specific pattern.
    /// - parameter pattern: The pattern to be matched to extract the value to be transformed
    /// - parameter transform: The transformation to be executed on values of cases matching pattern
    /// - returns: The transformed value if the enum case was matching the pattern, or nil.
    func flatMap<AssociatedValue, T>(case pattern: (AssociatedValue) -> Self, _ transform: (AssociatedValue) throws -> T?) rethrows -> T? {
        guard let value = associatedValue(matching: pattern) else { return nil }
        return try transform(value)
    }
    
    /// Do something when the enum matches a specific case. Can be chained with other `do`.
    /// - parameter case: The case to be matched
    /// - parameter execute: The block to be executed if the case match the pattern
    /// - returns: self
    @discardableResult
    func `do`(onCase case: Self, _ execute: () throws -> Void) rethrows -> Self {
        guard self ~= `case` else { return self }
        try execute()
        return self
    }
    
    /// Do something when the enum matches a specific pattern. Can be chained with other `do`.
    /// - parameter pattern: The pattern to be matched
    /// - parameter execute: The block to be executed if the case match the pattern
    /// - returns: self
    @discardableResult
    func `do`<AssociatedValue>(onCase pattern: (AssociatedValue) -> Self, _ execute: (AssociatedValue) throws -> Void) rethrows -> Self {
        guard let value = associatedValue(matching: pattern) else { return self }
        try execute(value)
        return self
    }
}

private extension CaseAccessible {
    func decompose<AssociatedValue>(expecting: AssociatedValue.Type) -> (path: [String?], value: AssociatedValue)? {
        let mirror = Mirror(reflecting: self)
        assert(mirror.displayStyle == .enum, "These CaseAccessible default functions should be used exclusively for enums")
        guard mirror.displayStyle == .enum else { return nil }
        
        var path: [String?] = []
        var any: Any = self
        
        while case let (label?, anyChild)? = Mirror(reflecting: any).children.first {
            path.append(label)
            path.append(String(describing: type(of: anyChild)))
            if let child = anyChild as? AssociatedValue { return (path, child) }
            any = anyChild
        }
        if MemoryLayout<AssociatedValue>.size == 0 {
            return (["\(self)"], unsafeBitCast((), to: AssociatedValue.self))
        }
        return nil
    }
}
