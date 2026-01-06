//
//  TestExecution.swift
//  E2ETesting
//
//  Created by Mulang Su on 20/12/2025.
//

import Foundation

public enum LogSeverity: Hashable {
    case meta
    case info
    case warning
    case failure
    case success
    case measurement
    
    var prefix: String {
        switch self {
        case .info, .meta:
            ""
        case .warning:
            "⚠️ "
        case .failure:
            "❌ "
        case .success:
            "✅ "
        case .measurement:
            "⏱️ "
        }
    }
}

@MainActor
public func _measure<T>(_ name: String, _ block: () async throws -> T, _ blockDescription: StaticString) async rethrows -> T {
    log("Start measuring '\(name)'...")
    let start = ContinuousClock.now
    let returnValue = try await block()
    let duration = ContinuousClock.now - start
    log("""
        Measurement '\(name)':
        
        ```swift
        \(blockDescription)
        ```
        
        Execution time: \(duration.formatted(
            .units(
                allowed: [.minutes, .seconds, .milliseconds],
                width: .narrow,
                zeroValueUnits: .show(length: 2)
            ).locale(Locale(identifier: "en-US_POSIX"))
        ))
        """, .measurement)
    return returnValue
}

@MainActor
public func log(_ message: String, _ severity: LogSeverity = .info) {
    precondition(TestingContext.currentTestMethod != nil, "Not testing!")
    let log = TestLog(severity: severity, message: message)
    TestingContext.currentTestMethod!.logs.append(log)
    print(log)
}

@MainActor
public func failTest(_ message: String, file: StaticString = #fileID, line: Int = #line, column: Int = #column) throws {
    let failure = TestFailure(message: message, file: file, line: line, column: column)
    log(failure.description, .failure)
    TestingContext.currentTestMethod?.state = .failure
    throw failure
}

@MainActor
public func _assertEqual<T: Equatable>(_ actual: T, _ actualExpression: StaticString, _ expected: T, _ expectedExpression: StaticString, _ stopIfFail: Bool, file: StaticString = #fileID, line: Int = #line, column: Int = #column) throws {
    if actual != expected {
        let actualDescription = String(reflecting: actual)
        let expectedDescription = String(reflecting: expected)
        let failure = TestFailure(
            message: "`\(actualExpression)` is not equal to `\(expectedExpression)`. Actual: `\(actualDescription)`, Expected: `\(expectedDescription)`",
            file: file, line: line, column: column
        )
        log(failure.description, .failure)
        TestingContext.currentTestMethod?.state = .failure
        if stopIfFail {
            throw failure
        }
    } else {
        log("`\(actualExpression)` is equal to `\(expectedExpression)`", .success)
    }
}

@MainActor
public func _assertNotEqual<T: Equatable>(_ actual: T, _ actualExpression: StaticString, _ expected: T, _ expectedExpression: StaticString, _ stopIfFail: Bool, file: StaticString = #fileID, line: Int = #line, column: Int = #column) throws {
    if actual == expected {
        let actualDescription = String(reflecting: actual)
        let failure = TestFailure(
            message: "`\(actualExpression)` is equal to `\(expectedExpression)`. Actual: `\(actualDescription)`",
            file: file, line: line, column: column
        )
        log(failure.description, .failure)
        TestingContext.currentTestMethod?.state = .failure
        if stopIfFail {
            throw failure
        }
    } else {
        log("`\(actualExpression)` is not equal to `\(expectedExpression)`", .success)
    }
}

@MainActor
public func _assertLessThan<T: Comparable>(_ actual: T, _ actualExpression: StaticString, _ expected: T, _ expectedExpression: StaticString, _ stopIfFail: Bool, file: StaticString = #fileID, line: Int = #line, column: Int = #column) throws {
    if !(actual < expected) {
        let actualDescription = String(reflecting: actual)
        let expectedDescription = String(reflecting: expected)
        let failure = TestFailure(
            message: "`\(actualExpression)` is not less than `\(expectedExpression)`. Actual: `\(actualDescription)`, Expected: `\(expectedDescription)`",
            file: file, line: line, column: column
        )
        log(failure.description, .failure)
        TestingContext.currentTestMethod?.state = .failure
        if stopIfFail {
            throw failure
        }
    } else {
        log("`\(actualExpression)` is less than `\(expectedExpression)`", .success)
    }
}

@MainActor
public func _assertGreaterThan<T: Comparable>(_ actual: T, _ actualExpression: StaticString, _ expected: T, _ expectedExpression: StaticString, _ stopIfFail: Bool, file: StaticString = #fileID, line: Int = #line, column: Int = #column) throws {
    if !(actual > expected) {
        let actualDescription = String(reflecting: actual)
        let expectedDescription = String(reflecting: expected)
        let failure = TestFailure(
            message: "`\(actualExpression)` is not greater than `\(expectedExpression)`. Actual: `\(actualDescription)`, Expected: `\(expectedDescription)`",
            file: file, line: line, column: column
        )
        log(failure.description, .failure)
        TestingContext.currentTestMethod?.state = .failure
        if stopIfFail {
            throw failure
        }
    } else {
        log("`\(actualExpression)` is greater than `\(expectedExpression)`", .success)
    }
}

@MainActor
public func _assertAtLeast<T: Comparable>(_ actual: T, _ actualExpression: StaticString, _ expected: T, _ expectedExpression: StaticString, _ stopIfFail: Bool, file: StaticString = #fileID, line: Int = #line, column: Int = #column) throws {
    if !(actual >= expected) {
        let actualDescription = String(reflecting: actual)
        let expectedDescription = String(reflecting: expected)
        let failure = TestFailure(
            message: "`\(actualExpression)` is not at least `\(expectedExpression)`. Actual: `\(actualDescription)`, Expected: `\(expectedDescription)`",
            file: file, line: line, column: column
        )
        log(failure.description, .failure)
        TestingContext.currentTestMethod?.state = .failure
        if stopIfFail {
            throw failure
        }
    } else {
        log("`\(actualExpression)` is at least `\(expectedExpression)`", .success)
    }
}

@MainActor
public func _assertAtMost<T: Comparable>(_ actual: T, _ actualExpression: StaticString, _ expected: T, _ expectedExpression: StaticString, _ stopIfFail: Bool, file: StaticString = #fileID, line: Int = #line, column: Int = #column) throws {
    if !(actual <= expected) {
        let actualDescription = String(reflecting: actual)
        let expectedDescription = String(reflecting: expected)
        let failure = TestFailure(
            message: "`\(actualExpression)` is not at most `\(expectedExpression)`. Actual: `\(actualDescription)`, Expected: `\(expectedDescription)`",
            file: file, line: line, column: column
        )
        log(failure.description, .failure)
        TestingContext.currentTestMethod?.state = .failure
        if stopIfFail {
            throw failure
        }
    } else {
        log("`\(actualExpression)` is at most `\(expectedExpression)`", .success)
    }
}

@MainActor
public func _assertTrue(_ actual: Bool, _ actualExpression: StaticString, _ stopIfFail: Bool, file: StaticString = #fileID, line: Int = #line, column: Int = #column) throws {
    if !actual {
        let failure = TestFailure(
            message: "`\(actualExpression)` is not `true`.",
            file: file, line: line, column: column
        )
        log(failure.description, .failure)
        TestingContext.currentTestMethod?.state = .failure
        if stopIfFail {
            throw failure
        }
    } else {
        log("`\(actualExpression)` is `true`.", .success)
    }
}

@MainActor
public func _assertFalse(_ actual: Bool, _ actualExpression: StaticString, _ stopIfFail: Bool, file: StaticString = #fileID, line: Int = #line, column: Int = #column) throws {
    if actual {
        let failure = TestFailure(
            message: "`\(actualExpression)` is not `false`.",
            file: file, line: line, column: column
        )
        log(failure.description, .failure)
        TestingContext.currentTestMethod?.state = .failure
        if stopIfFail {
            throw failure
        }
    } else {
        log("`\(actualExpression)` is `false`.", .success)
    }
}

@MainActor
@discardableResult
public func _assertNotNil<T>(_ actual: T?, _ actualExpression: StaticString, file: StaticString = #fileID, line: Int = #line, column: Int = #column) throws -> T {
    guard let actual else {
        let failure = TestFailure(
            message: "`\(actualExpression)` is `nil`!",
            file: file, line: line, column: column
        )
        log(failure.description, .failure)
        TestingContext.currentTestMethod?.state = .failure
        throw failure
    }
    log("`\(actualExpression)` is not nil.", .success)
    return actual
}

@MainActor
public func _assertNil<T>(_ actual: T?, _ actualExpression: StaticString, _ stopIfFail: Bool, file: StaticString = #fileID, line: Int = #line, column: Int = #column) throws {
    if let actual {
        let actualDescription = String(reflecting: actual)
        let failure = TestFailure(
            message: "`\(actualExpression)` is not `nil`! Actual: \(actualDescription)",
            file: file, line: line, column: column
        )
        log(failure.description, .failure)
        TestingContext.currentTestMethod?.state = .failure
        if stopIfFail {
            throw failure
        }
    } else {
        log("`\(actualExpression)` is nil.", .success)
    }
}

@MainActor
public func _assertContains<S: Sequence>(_ sequence: S, _ sequenceExpression: StaticString, _ element: S.Element, _ elementExpression: StaticString, _ stopIfFail: Bool, file: StaticString = #fileID, line: Int = #line, column: Int = #column) throws
    where S.Element: Equatable {
    if !sequence.contains(element) {
        let sequenceDescription = String(reflecting: sequence)
        let elementDescription = String(reflecting: element)
        let failure = TestFailure(
            message: "`\(sequenceExpression)` does not contain `\(elementExpression)`! Sequence: `\(sequenceDescription)`, Expected Element: `\(elementDescription)`",
            file: file, line: line, column: column
        )
        log(failure.description, .failure)
        TestingContext.currentTestMethod?.state = .failure
        if stopIfFail {
            throw failure
        }
    } else {
        log("`\(sequenceExpression)` contains `\(elementExpression)`.", .success)
    }
}

@MainActor
public func _assertNotContains<S: Sequence>(_ sequence: S, _ sequenceExpression: StaticString, _ element: S.Element, _ elementExpression: StaticString, _ stopIfFail: Bool, file: StaticString = #fileID, line: Int = #line, column: Int = #column) throws
    where S.Element: Equatable {
    if sequence.contains(element) {
        let sequenceDescription = String(reflecting: sequence)
        let elementDescription = String(reflecting: element)
        let failure = TestFailure(
            message: "`\(sequenceExpression)` unexpectedly contains `\(elementExpression)`! Sequence: `\(sequenceDescription)`, Unexpected Element: `\(elementDescription)`",
            file: file, line: line, column: column
        )
        log(failure.description, .failure)
        TestingContext.currentTestMethod?.state = .failure
        if stopIfFail {
            throw failure
        }
    } else {
        log("`\(sequenceExpression)` does not contain `\(elementExpression)`.", .success)
    }
}
