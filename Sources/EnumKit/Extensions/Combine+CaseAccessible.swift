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
    
    func map<T>(case: Output, _ transform: @escaping () -> T) -> Publishers.Map<AnyPublisher<Void, Failure>, T> {
        return capture(case: `case`).map(transform)
    }
    
    func map<AssociatedValue, T>(case pattern: @escaping (AssociatedValue) -> Output, _ transform: @escaping (AssociatedValue) -> T) -> Publishers.Map<AnyPublisher<AssociatedValue, Failure>, T> {
        return capture(case: pattern).map(transform)
    }
    
    /// Calls a closure with each received element that match the provided case and publishes any returned optional that has a value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A closure invoked when a value match the provided case and returns an optional value.
    /// - returns: A publisher that republishes all non-nil results of calling the transform closure.
    func compactMap<T>(case: Output, _ transform: @escaping () -> T?) -> Publishers.CompactMap<Self, T> {
        return compactMap {
            guard $0 ~= `case` else { return nil }
            return transform()
        }
    }
    
    /// Calls a closure with each received element that match the provided case and publishes any returned optional that has a value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A closure that receives an associated value for a matching case and returns an optional value.
    /// - returns: A publisher that republishes all non-nil results of calling the transform closure.
    func compactMap<AssociatedValue, T>(case pattern: @escaping (AssociatedValue) -> Output, _ transform: @escaping (AssociatedValue) -> T?) -> Publishers.CompactMap<Self, T> {
        return compactMap {
            guard let value = $0[case: pattern] else { return nil }
            return transform(value)
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
public extension Publisher where Output == CaseAccessible {
    
    private func model<T: CaseAccessible>(_ type: T.Type) -> AnyPublisher<T, Failure> {
        return compactMap { $0 as? T }.eraseToAnyPublisher()
    }
    
    /// Republishes all elements that match a provided case.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: A publisher that republishes all elements that match the case.
    func filter<T: CaseAccessible>(case: T) -> Publishers.Filter<AnyPublisher<T, Failure>> {
        return model(T.self).filter(case: `case`)
    }
    
    /// Republishes all elements that match a provided case.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: A publisher that republishes all elements that match the case.
    func filter<T: CaseAccessible, AssociatedValue>(case pattern: @escaping (AssociatedValue) -> T) -> Publishers.Filter<AnyPublisher<T, Failure>> {
        return model(T.self).filter(case: pattern)
    }
    
    /// Republishes all elements that do not match a provided case.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: A publisher that republishes all elements that do not match the case.
    func exclude<T: CaseAccessible>(case: T) -> Publishers.Filter<AnyPublisher<T, Failure>> {
        return model(T.self).exclude(case: `case`)
    }
    
    /// Republishes all elements that do not match a provided case.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: A publisher that republishes all elements that do not match the case.
    func exclude<T: CaseAccessible, AssociatedValue>(case pattern: @escaping (AssociatedValue) -> T) -> Publishers.Filter<AnyPublisher<T, Failure>> {
        return model(T.self).exclude(case: pattern)
    }
    
    /// Projects each matching enum case of a Publisher into its associated value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: A publisher that republishes all matching results of case.
    func capture<T: CaseAccessible>(case: T) -> AnyPublisher<Void, Failure> {
        return model(T.self).capture(case: `case`)
    }
    
    /// Projects each matching enum case of a Publisher into its associated value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - returns: A publisher that republishes all matching results of case.
    func capture<T: CaseAccessible, AssociatedValue>(case pattern: @escaping (AssociatedValue) -> T) -> AnyPublisher<AssociatedValue, Failure> {
        return model(T.self).capture(case: pattern)
    }
    
    func map<T, U: CaseAccessible>(case: U, _ transform: @escaping () -> T) -> Publishers.Map<AnyPublisher<Void, Failure>, T> {
        return model(U.self).map(case: `case`, transform)
    }
    
    func map<AssociatedValue, T, U: CaseAccessible>(case pattern: @escaping (AssociatedValue) -> U, _ transform: @escaping (AssociatedValue) -> T) -> Publishers.Map<AnyPublisher<AssociatedValue, Failure>, T> {
        return model(U.self).map(case: pattern, transform)
    }
    
    /// Calls a closure with each received element that match the provided case and publishes any returned optional that has a value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A closure invoked when a value match the provided case and returns an optional value.
    /// - returns: A publisher that republishes all non-nil results of calling the transform closure.
    func compactMap<T, U: CaseAccessible>(case: U, _ transform: @escaping () -> T?) -> Publishers.CompactMap<AnyPublisher<U, Failure>, T> {
        return model(U.self).compactMap(case: `case`, transform)
    }
    
    /// Calls a closure with each received element that match the provided case and publishes any returned optional that has a value.
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter transform: A closure that receives an associated value for a matching case and returns an optional value.
    /// - returns: A publisher that republishes all non-nil results of calling the transform closure.
    func compactMap<AssociatedValue, T, U: CaseAccessible>(case pattern: @escaping (AssociatedValue) -> U, _ transform: @escaping (AssociatedValue) -> T?) -> Publishers.CompactMap<AnyPublisher<U, Failure>, T> {
        return model(U.self).compactMap(case: pattern, transform)
    }
    
    /// Transforms all elements from an upstream publisher that match the provided case into a new or existing publisher
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter maxPublishers: The maximum number of publishers produced by this method
    /// - parameter transform: A closure invoked whenever upstream output matches the provided case and returns a publisher that produces elements of that type.
    /// - returns: A publisher that transforms elements from an upstream publisher into a publisher of that element’s type when they match the provided case.
    func flatMap<T, P : Publisher, U: CaseAccessible>(case: U,
                                   maxPublishers: Subscribers.Demand = .unlimited,
                                   _ transform: @escaping () -> P) -> Publishers.FlatMap<P, AnyPublisher<Void, Failure>>
        where T == P.Output , Failure == P.Failure {
            return model(U.self).flatMap(case: `case`, maxPublishers: maxPublishers, transform)
    }
    
    /// Transforms all elements from an upstream publisher that match the provided case into a new or existing publisher
    /// - parameter case: An enum case to test each source element for a matching condition.
    /// - parameter maxPublishers: The maximum number of publishers produced by this method
    /// - parameter transform: A closure that takes an associated value as a parameter and returns a publisher that produces elements of that type.
    /// - returns: A publisher that transforms elements from an upstream publisher into a publisher of that element’s type when they match the provided case.
    func flatMap<T, P : Publisher, AssociatedValue, U: CaseAccessible>(case pattern: @escaping (AssociatedValue) -> U,
                                                    maxPublishers: Subscribers.Demand = .unlimited,
                                                    _ transform: @escaping (AssociatedValue) -> P) -> Publishers.FlatMap<P, AnyPublisher<AssociatedValue, Failure>>
        where T == P.Output , Failure == P.Failure {
            return model(U.self).flatMap(case: pattern, maxPublishers: maxPublishers, transform)
    }
}

#endif
