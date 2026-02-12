//
//  Reliability.swift
//  E2ETesting
//
//  Created by Mulang Su on 12/2/2026.
//

import Foundation

@MainActor
public func runReliabilityTests(iterations: Int, block: () async throws -> Void) async throws {
    guard let testMethod = TestingContext.currentTestMethod else {
        fatalError("Not testing!")
    }
    
    testMethod.reliabilityStats = ReliabilityStats()
    testMethod.reliabilityStats?.totalCount = iterations
    var squares = ""
    var errorMessages = [String]()
    for _ in 0..<iterations {
        do {
            try Task.checkCancellation()
            try await block()
        } catch is CancellationError {
            break
        } catch {
            testMethod.reliabilityStats?.failureCount += 1
            squares.append("🟥")
            errorMessages.append("\(error)")
            continue
        }
        testMethod.reliabilityStats?.successCount += 1
        squares.append("🟩")
    }
    testMethod.logs = []
    let stats = testMethod.reliabilityStats!
    
    log(squares)
    log("Total iterations: \(stats.failureCount + stats.successCount)")
    log("Success: \(stats.successCount)")
    log("Failure: \(stats.failureCount)")
    for error in errorMessages {
        log(error, .failure)
    }
    let rate = Double(stats.successCount) / Double(stats.failureCount + stats.successCount)
    log("Success Rate: \(rate.formatted(.percent))")
}
