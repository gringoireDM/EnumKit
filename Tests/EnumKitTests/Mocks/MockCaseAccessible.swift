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
}
