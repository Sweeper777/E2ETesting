
@freestanding(expression)
public macro assertEqual<T: Equatable>(_ actual: T, _ expected: T, stopIfFail: Bool)
    = #externalMacro(module: "E2ETestingMacros", type: "AssertMacro")

@freestanding(expression)
public macro assertNotEqual<T: Equatable>(_ actual: T, _ expected: T, stopIfFail: Bool)
    = #externalMacro(module: "E2ETestingMacros", type: "AssertMacro")

@freestanding(expression)
public macro assertLessThan<T: Comparable>(_ actual: T, _ expected: T, stopIfFail: Bool)
    = #externalMacro(module: "E2ETestingMacros", type: "AssertMacro")

@freestanding(expression)
public macro assertGreaterThan<T: Comparable>(_ actual: T, _ expected: T, stopIfFail: Bool)
    = #externalMacro(module: "E2ETestingMacros", type: "AssertMacro")

@freestanding(expression)
public macro assertAtMost<T: Comparable>(_ actual: T, _ expected: T, stopIfFail: Bool)
    = #externalMacro(module: "E2ETestingMacros", type: "AssertMacro")

@freestanding(expression)
public macro assertAtLeast<T: Comparable>(_ actual: T, _ expected: T, stopIfFail: Bool)
    = #externalMacro(module: "E2ETestingMacros", type: "AssertMacro")

@freestanding(expression)
public macro assertNotNil<T>(_ actual: T?) -> T
    = #externalMacro(module: "E2ETestingMacros", type: "AssertMacro")

@freestanding(expression)
public macro assertNil<T>(_ actual: T?, stopIfFail: Bool)
    = #externalMacro(module: "E2ETestingMacros", type: "AssertMacro")

@freestanding(expression)
public macro assertTrue(_ actual: Bool, stopIfFail: Bool)
    = #externalMacro(module: "E2ETestingMacros", type: "AssertMacro")

@freestanding(expression)
public macro assertFalse(_ actual: Bool, stopIfFail: Bool)
    = #externalMacro(module: "E2ETestingMacros", type: "AssertMacro")

@freestanding(expression)
public macro assertContains<S: Sequence>(_ sequence: S, _ element: S.Element, stopIfFail: Bool)
    = #externalMacro(module: "E2ETestingMacros", type: "AssertMacro")
where S.Element: Equatable

@freestanding(expression)
public macro assertNotContains<S: Sequence>(_ sequence: S, _ element: S.Element, stopIfFail: Bool)
    = #externalMacro(module: "E2ETestingMacros", type: "AssertMacro")
where S.Element: Equatable

@freestanding(expression)
public macro measure<T>(_ name: String, _ block: () async throws -> T) -> T
    = #externalMacro(module: "E2ETestingMacros", type: "MeasureMacro")

@attached(member, names: named(testMethods), named(name), named(testMethodNames), named(init))
@attached(extension, conformances: TestSuite)
public macro TestSuite(_ name: String = "")
    = #externalMacro(module: "E2ETestingMacros", type: "TestSuiteMacro")

@attached(peer)
public macro TestMethod(_ name: String = "")
    = #externalMacro(module: "E2ETestingMacros", type: "TestMethodMacro")
