//
//  Combine+CaseAccessible.swift
//  EnumKit
//
//  Created by Giuseppe Lanza on 17/08/2019.
//

#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Output: CaseAccessible {
    
    /// Republishes all elements that match a provided case.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: A publisher that republishes all elements that match the case.
    func filter(case: Output) -> Publishers.Filter<Self> {
        return filter { $0 ~= `case` }
    }
    
    /// Republishes all elements that match a provided case.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: A publisher that republishes all elements that match the case.
    func filter<AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Output) -> Publishers.Filter<Self> {
        return filter { $0 ~= pattern }
    }
    
    /// Republishes all elements that do not match a provided case.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: A publisher that republishes all elements that do not match the case.
    func exclude(case: Output) -> Publishers.Filter<Self> {
        return filter { $0 !~= `case` }
    }
    
    /// Republishes all elements that do not match a provided case.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: A publisher that republishes all elements that do not match the case.
    func exclude<AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Output) -> Publishers.Filter<Self> {
        return filter { $0 !~= pattern }
    }
    
    /// Projects each matching enum case of a Publisher into its associated value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: A publisher that republishes all matching results of case.
    func capture(case: Output) -> AnyPublisher<Void, Failure> {
        return compactMap { $0 ~= `case` ? () : nil }.eraseToAnyPublisher()
    }
    
    /// Projects each matching enum case of a Publisher into its associated value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: A publisher that republishes all matching results of case.
    func capture<AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Output) -> AnyPublisher<AssociatedValue, Failure> {
        return compactMap { $0[case: pattern] }.eraseToAnyPublisher()
    }
    
    /// Calls a closure with each received element that match the provided case and publishes any returned optional that has a value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A closure invoked when a value match the provided case and returns an optional value.
    /// - returns: A publisher that republishes all non-nil results of calling the transform closure.
    func compactMap<T>(case: Output, _ transorm: @escaping () -> T?) -> Publishers.CompactMap<Self, T> {
        return compactMap {
            guard $0 ~= `case` else { return nil }
            return transorm()
        }
    }
    
    /// Calls a closure with each received element that match the provided case and publishes any returned optional that has a value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A closure that receives an associated value for a matching case and returns an optional value.
    /// - returns: A publisher that republishes all non-nil results of calling the transform closure.
    func compactMap<AssociatedValue, T>(case pattern: @escaping (AssociatedValue) -> Output, _ transorm: @escaping (AssociatedValue) -> T?) -> Publishers.CompactMap<Self, T> {
        return compactMap {
            guard let value = $0[case: pattern] else { return nil }
            return transorm(value)
        }
    }
    
    /// Transforms all elements from an upstream publisher that match the provided case into a new or existing publisher
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter maxPublishers: The maximum number of publishers produced by this method
    /// - parameter transform: A closure invoked whenever upstream output matches the provided case and returns a publisher that produces elements of that type.
    /// - returns: A publisher that transforms elements from an upstream publisher into a publisher of that element’s type when they match the provided case.
    func flatMap<T, P : Publisher>(case: Output,
                                   maxPublishers: Subscribers.Demand = .unlimited,
                                   _ transform: @escaping () -> P) -> Publishers.FlatMap<P, AnyPublisher<Void, Failure>>
        where T == P.Output , Failure == P.Failure {
            return capture(case: `case`)
                .flatMap(maxPublishers: maxPublishers, transform)
    }
    
    /// Transforms all elements from an upstream publisher that match the provided case into a new or existing publisher
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter maxPublishers: The maximum number of publishers produced by this method
    /// - parameter transform: A closure that takes an associated value as a parameter and returns a publisher that produces elements of that type.
    /// - returns: A publisher that transforms elements from an upstream publisher into a publisher of that element’s type when they match the provided case.
    func flatMap<T, P : Publisher, AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Output,
                                                    maxPublishers: Subscribers.Demand = .unlimited,
                                                    _ transform: @escaping (AssociatedValue) -> P) -> Publishers.FlatMap<P, AnyPublisher<AssociatedValue, Failure>>
        where T == P.Output , Failure == P.Failure {
            return capture(case: pattern)
                .flatMap(maxPublishers: maxPublishers, transform)
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func map<T: CaseAccessible>(toCase case: T) -> Publishers.Map<Self, T> {
        return map { _ in `case` }
    }
    
    func map<T: CaseAccessible>(toCase pattern: @escaping (Output) -> T) -> Publishers.Map<Self, T> {
        return map(pattern)
    }
}

#endif
