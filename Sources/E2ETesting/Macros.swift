
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
public macro assertNotNil<T>(_ actual: T?) -> T
    = #externalMacro(module: "E2ETestingMacros", type: "AssertMacro")

@freestanding(expression)
public macro assertNil<T>(_ actual: T?, stopIfFail: Bool)
    = #externalMacro(module: "E2ETestingMacros", type: "AssertMacro")

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
