//
//  CaseAccessible.swift
//  EnumKit
//
//  Created by Giuseppe Lanza on 13/08/2019.
//

import Foundation

public protocol CaseAccessible { }
public extension CaseAccessible {
    /// returns the label of the enum case
    var label: String {
        return Mirror(reflecting: self).children.first?.label ?? String(describing: self)
    }
    
    /// check if an enum case matches another case
    func matches(case: Self) -> Bool {
        let targetStr = `case`.label
        return label == targetStr
    }
    
    /// check if an enum case matches a specific pattern
    func matches<Payload>(case pattern: (Payload) -> Self) -> Bool {
        return associatedValue(matching: pattern) != nil
    }
    
    /// Extract an associated value of the enum case if it is of the expected type
    func associatedValue<AssociatedValue>() -> AssociatedValue? {
        return decompose()?.value
    }
    
    /// Extract the associated value of the enum case if it matches a specific pattern
    func associatedValue<AssociatedValue>(matching pattern: (AssociatedValue) -> Self) -> AssociatedValue? {
        guard let decomposed: (String, AssociatedValue) = decompose(),
            let patternDecomposed: (String, AssociatedValue) = pattern(decomposed.1).decompose(),
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
    /// - parameter pattern: The pattern to be matched extract the value to be transformed
    /// - parameter transform: The transformation to be executed on values of cases matching pattern
    /// - returns: The transformed value if the enum case was matching the pattern, or nil.
    func map<AssociatedValue, T>(case pattern: (AssociatedValue) -> Self, _ transform: (AssociatedValue) throws -> T) rethrows -> T? {
        guard let value = associatedValue(matching: pattern) else { return nil }
        return try transform(value)
    }
    
    /// Map the associated value of the enum case to another type, if the case match a specific pattern.
    /// - parameter pattern: The pattern to be matched extract the value to be transformed
    /// - parameter transform: The transformation to be executed on values of cases matching pattern
    /// - returns: The transformed value if the enum case was matching the pattern, or nil.
    func flatMap<AssociatedValue, T>(case pattern: (AssociatedValue) -> Self, _ transform: (AssociatedValue) throws -> T?) rethrows -> T? {
        guard let value = associatedValue(matching: pattern) else { return nil }
        return try transform(value)
    }
}

private extension CaseAccessible {
    func decompose<AssociatedValue>() -> (label: String, value: AssociatedValue)? {
        let mirror = Mirror(reflecting: self)
        assert(mirror.displayStyle == .enum, "These CaseAccessible default functions should be used exclusively for enums")
        guard mirror.displayStyle == .enum,
            let pair = Mirror(reflecting: self).children.first,
            let label = pair.label,
            let result = (pair.value as? AssociatedValue) ??
                (Mirror(reflecting: pair.value).children.first?.value as? AssociatedValue) else {
                    return nil
        }
        return (label, result)
    }
}
