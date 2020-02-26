//
//  MockCaseAccessible.swift
//  EnumKitTests
//
//  Created by Giuseppe Lanza on 13/08/2019.
//

import Foundation
import EnumKit

enum MockEnum: CaseAccessible, Equatable {
    case noAssociatedValue
    case anotherWithoutAssociatedValue
    case withAnonymousPayload(String)
    case withNamedPayload(payload: String)
    case anInt(Int)
    case anotherInt(Int)
    case namedInt(integer: Int)
    case zeroSized(ZeroSized)
    case overloading(Int)
    case overloading(string: String)
    case overloading(anInt: Int)
    case overloading(anInt: Int, andString: String)
}

struct ZeroSized: Equatable {
    static func == (lhs: ZeroSized, rhs: ZeroSized) -> Bool { true }
}
