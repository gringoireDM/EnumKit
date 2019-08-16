# EnumKit

How to access an associated value of an enum case is a very recurring question on stackOverflow.

`EnumKit` gives you the ability to simply access an enum value without having to use pattern matching.

### Index
  * [Access an associated value](#access-an-associated-value)
  * [Matching cases](#matching-cases)
  * [Updatathing an enum value](#updatathing-an-enum-value)
  * [Transform associated values](#transform-associated-values)
    
## Access an associated value

There are two ways to access an associated value of an enum case

### By type

The first is by specifying which is your return type and using the `associatedValue()` function.

```swift
let value: String? = someCase.associatedValue()
// or with subscript
let value = someCase[expecting: String.self] // String?
```

This will return a string if the associated value of this enum instance is actually a string, regardless of which is the actual case. This is particularly useful for those enums that have similar cases, like

```swift
enum MyError: CaseAccessible, Error {
    case notFound(String)
    case noConnection(String)
    case failedWithMessage(String)
}
```

### By case

The second way to access an enum associated value is to optionally extract it when the instance is matching a specific case, using the `associatedValue(matching:)` function:

```
let myError: MyError
let errorMessage = myError.associatedValue(matching: MyError.noConnection) // String?
// or with subscript
let errorMessage = myError[case: MyError.noConnection] // String?
```

## Matching cases

EnumKit provides utilities functions for case matching. 

```
// is matching

let isConnectionIssue = myError.matches(case: MyError.noConnection)
//or with ~= operator
let isConnectionIssue = myError ~= MyError.noConnection

// is not matching

let isNotConnectionIssue = myError.isNotMatching(case: MyError.noConnection)
// or with !~= operator
let isNotConnectionIssue = myError !~= MyError.noConnection
```

## Updatathing an enum value

Currently to update an associated value of an enum value is very verbose.

Let's take in consideration a simple example: 

```swift
enum State: CaseAccessible {
    case count(Int)
    case error
}
```

This code change the value of an enum instance when this represent a `count` case:

```swift
func changeCount(_ state: inout State, to newValue: Int) {
    guard case .count = state else { return }
    state = State.count(newValue)
}

func incrementCount(_ state: inout State, by increment: Int) {
    guard case let .count(value) = state else { return }
    state = State.count(value + increment)
}
```

while with EnumKit this becomes

```swift
func changeCount(_ state: inout State, to newValue: Int) -> State {
    state[case: State.count] = newValue
}

func incrementCount(_ state: inout State, by increment: Int) {
    state[case: State.count, default: 0] += increment
}
```

## Transform associated values

Similarly to `Optional`, EnumKit offers `map` and `flatMap` functions to transform associated values, when the enum is `CaseAccessible`

```swift
struct Person {
    var name: String
    var lastName: String
}

enum MyEnum: CaseAccessible {
    case myString(String)
    case myInt(Int)
    case myPerson(Person)
}

let aCase: MyEnum
...

let stringValue = aCase.map(case: MyEnum.myInt) { "\($0)" } // String?
let name = aCase.map(case: MyEnum.myPerson) { $0.name } // String?
let maybeInt = aCase.flatMap(case: MyEnum.myString) { Int($0) } // Int?
```

These operators work exactly the same as for `Optional`. While `Optional` `map` and `flatMap` functions will invoke the transformation just when `Optional` case is `some`, the equivalent functions will invoke the transformation just if they match the specific case specified in the `case` parameter.
