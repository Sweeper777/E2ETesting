//
//  TestRunner.swift
//  E2ETesting
//
//  Created by Mulang Su on 20/12/2025.
//

@MainActor
public enum TestRunner {
    @discardableResult
    public static func run(_ tests: [any TestSuite.Type]) async throws -> TestReport {
        var suites = [TestSuite]()
        for test in tests {
            try Task.checkCancellation()
            suites.append(contentsOf: try await run(test).suites)
        }
        return TestReport(suites: suites)
    }
    
    public static func run<T: TestSuite>(_ testType: T.Type) async throws -> TestReport {
        let test = testType.init()
        TestNotification.postStart(test)
        defer { TestNotification.postEnd(test) }
        for method in test.testMethods {
            try await runOneMethod(test, method: method)
        }
        return TestReport(suites: [test])
    }
    
    private static func runOneMethod(_ test: some TestSuite, method: TestMethod) async throws {
        try Task.checkCancellation()
        TestingContext.currentTestMethod = method
        defer { TestingContext.currentTestMethod = nil }
        method.state = .running
        
        log("Setting up test: '\(method.name)'...", .meta)
        do {
            try await test.setUp()
        } catch let e as CancellationError {
            method.state = .unknown
            throw e
        } catch {
            log("Failed to set up test '\(method.name)': \(error)", .failure)
            method.state = .failure
            return
        }
        log("Running test: '\(method.name)'...", .meta)
        
        do {
            try await method.block()
            if method.state == .running {
                method.state = .success
            }
        } catch is TestFailure {
            
        } catch let e as CancellationError {
            method.state = .unknown
            throw e
        } catch {
            log("Caught error when running test '\(method.name)': \(error)", .failure)
            method.state = .failure
        }
        
        log("Tearing down test: '\(method.name)'...", .meta)
        do {
            try await test.tearDown()
        } catch let e as CancellationError {
            throw e
        } catch {
            log("Failed to tear down test '\(method.name)': \(error)", .failure)
        }
    }
    
    @discardableResult
    public static func run<T: TestSuite>(_ testType: T.Type, methodName: String) async throws -> TestReport {
        let test = testType.init()
        TestNotification.postStart(test)
        defer { TestNotification.postEnd(test) }
        try await runOneMethod(test, method: test.testMethods.first(where: { $0.name == methodName })!)
        return TestReport(suites: [test])
    }
}
