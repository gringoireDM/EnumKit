//
//  CapturePublisher.swift
//  EnumKitTests
//
//  Created by Giuseppe Lanza on 30/09/2019.
//

#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {
    public struct Capture<Upstream, Output> : Publisher where Upstream : Publisher {
        public typealias Failure = Upstream.Failure
        public let upstream: Upstream

        let matcher: (Upstream.Output) -> Output?
        
        internal init(upstream: Upstream, _ matcher: @escaping (Upstream.Output) -> Output?) {
            self.upstream = upstream
            self.matcher = matcher
        }
        
        public func receive<S>(subscriber: S)
            where S : Subscriber, Failure == S.Failure, Output == S.Input {
                return upstream.compactMap(matcher).receive(subscriber: subscriber)
        }
    }
    
    public struct MapCase<Upstream, Intermediate, Output> : Publisher where Upstream : Publisher {
        public typealias Failure = Upstream.Failure
        public let upstream: Upstream

        let matcher: (Upstream.Output) -> Intermediate?
        let transform: (Intermediate) -> Output
        
        internal init(upstream: Upstream,
                      _ matcher: @escaping (Upstream.Output) -> Intermediate?,
                      transform: @escaping (Intermediate) -> Output) {
            self.upstream = upstream
            self.matcher = matcher
            self.transform = transform
        }
        
        public func receive<S>(subscriber: S)
            where S : Subscriber, Failure == S.Failure, Output == S.Input {
                return upstream.compactMap(matcher)
                    .map(transform)
                    .receive(subscriber: subscriber)
        }
    }
    
    public struct FlatMapCase<NewPublisher, Upstream, Intermediate> : Publisher where Upstream : Publisher, NewPublisher : Publisher, NewPublisher.Failure == Upstream.Failure {
        public typealias Output = NewPublisher.Output
        public typealias Failure = Upstream.Failure
        public let upstream: Upstream
        public let maxPublishers: Subscribers.Demand

        let matcher: (Upstream.Output) -> Intermediate?
        let transform: (Intermediate) -> NewPublisher
        
        internal init(upstream: Upstream,
                      maxPublishers: Subscribers.Demand,
                      _ matcher: @escaping (Upstream.Output) -> Intermediate?,
                      transform: @escaping (Intermediate) -> NewPublisher) {
            self.upstream = upstream
            self.maxPublishers = maxPublishers
            self.matcher = matcher
            self.transform = transform
        }
        
        public func receive<S>(subscriber: S)
            where S : Subscriber, Failure == S.Failure, Output == S.Input {
                return upstream.compactMap(matcher)
                    .flatMap(maxPublishers: maxPublishers, transform)
                    .receive(subscriber: subscriber)
        }
    }
    
    public struct ToType<Upstream, Output> : Publisher where Upstream : Publisher {
        public typealias Failure = Upstream.Failure
        
        public let upstream: Upstream

        internal init(upstream: Upstream, type: Output.Type) {
            self.upstream = upstream
        }
        
        public func receive<S>(subscriber: S)
            where S : Subscriber, Failure == S.Failure, Output == S.Input {
                return upstream.compactMap { $0 as? Output }.receive(subscriber: subscriber)
        }

    }
}

#endif
