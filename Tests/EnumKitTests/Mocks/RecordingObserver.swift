//
//  MockObserver.swift
//  EnumKit
//
//  Created by Giuseppe Lanza on 29/09/2019.
//

#if canImport(Combine)
import Combine
import Foundation

enum CombineEvents<Input, Failure> where Failure : Error {
    case next(Input)
    case subscribed
    case error(Failure)
    case completed
}

extension CombineEvents: Equatable
    where Input: Equatable, Failure: Equatable { }

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class RecordingObserver<Input, Failure>: Subscriber, Cancellable where Failure : Error {
    var subscription: Subscription?
    var events = [CombineEvents<Input, Failure>]()
    
    final let receiveValue: (Input) -> Void
    final let receiveCompletion: (Subscribers.Completion<Failure>) -> Void

    init(receiveValue: @escaping (Input) -> Void,
         receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void = { _ in }) {
        self.receiveValue = receiveValue
        self.receiveCompletion = receiveCompletion
    }
    
    func receive(subscription: Subscription) {
        self.subscription = subscription
        events.append(.subscribed)
        subscription.request(.unlimited)
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        events.append(.next(input))
        return .unlimited
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        guard case let .failure(error) = completion else {
            events.append(.completed)
            return
        }
        events.append(.error(error))
    }
    
    func cancel() { subscription?.cancel() }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    func record(receiveCompletion: @escaping ((Subscribers.Completion<Failure>) -> Void) = { _ in },
                receiveValue: @escaping ((Output) -> Void) = { _ in }) -> RecordingObserver<Output, Failure> {
        let recordingObs = RecordingObserver(receiveValue: receiveValue, receiveCompletion: receiveCompletion)
        
        subscribe(on: ImmediateScheduler.shared).subscribe(recordingObs)
        
        return recordingObs
    }
}

#endif
