//
//  MockCaseAccessible.swift
//  EnumKitTests
//
//  Created by Giuseppe Lanza on 13/08/2019.
//

import Foundation
import EnumKit

enum MockEnum: CaseAccessible {
    case noAssociatedValue
    case anotherWithoutAssociatedValue
    case withAnonymousPayload(String)
    case withNamedPayload(payload: String)
    case anInt(Int)
}
