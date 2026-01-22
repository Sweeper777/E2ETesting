//
//  Expectation.swift
//  E2ETesting
//
//  Created by Mulang Su on 20/12/2025.
//

import Foundation
import Combine

private let expectationFulfilledNotificationName = Notification.Name("E2ETestingExpectationFulfilled")

public actor Expectation {
    public let expectedFulfilmentCount: Int
    public var actualFulfilmentCount = 0
    
    public var fullyFulfilled: Bool {
        expectedFulfilmentCount <= actualFulfilmentCount
    }
    
    public let name: String
    
    public init(name: String, expectedFulfilmentCount: Int = 1) {
        self.name = name
        self.expectedFulfilmentCount = expectedFulfilmentCount
    }
    
    public func fulfillIsolated() {
        actualFulfilmentCount += 1
        NotificationCenter.default.post(name: expectationFulfilledNotificationName, object: self)
    }
    
    public nonisolated func fulfill() {
        Task {
            await fulfillIsolated()
        }
    }
}

private struct Timeout: Error {}

@MainActor
public func fulfilment(of expectations: [Expectation], timeout: TimeInterval, stopIfFail: Bool, file: StaticString = #fileID, line: Int = #line, column: Int = #column) async throws {
    try await withThrowingTaskGroup { group in
        group.addTask {
            try await Task.sleep(for: .seconds(timeout))
            throw Timeout()
        }
        for expectation in expectations {
            group.addTask {
                if await expectation.fullyFulfilled {
                    let expected = expectation.expectedFulfilmentCount
                    await log("Expectation '\(expectation.name)' fulfilled \(expected) time(s) as expected.", .success)
                    return
                }
                for await _ in NotificationCenter.default.notifications(named: expectationFulfilledNotificationName, object: expectation) {
                    if await expectation.fullyFulfilled {
                        break
                    }
                }
                let expected = expectation.expectedFulfilmentCount
                let actual = await expectation.actualFulfilmentCount
                if expected <= actual {
                    await log("Expectation '\(expectation.name)' fulfilled \(expected) time(s) as expected.", .success)
                } else {
                    await log("Expectation '\(expectation.name)' is fulfilled \(actual) time(s), but \(expected) time(s) were expected.", .failure)
                }
            }
        }
        do {
            for try await _ in group.prefix(expectations.count) {
                
            }
        } catch {
            let failure = TestFailure(message: "Expectations are not fulfilled as expected.", file: file, line: line, column: column)
            log(failure.description, .failure)
            TestingContext.currentTestMethod?.state = .failure
            if stopIfFail {
                throw failure
            }
        }
        group.cancelAll()
    }
}
