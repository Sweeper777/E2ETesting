//
//  TestMethod.swift
//  E2ETesting
//
//  Created by Mulang Su on 20/12/2025.
//

import Observation

@Observable
@MainActor
public final class TestMethod: Identifiable {
    public let name: String
    public let block: () async throws -> Void
    public var logs: [TestLog] = []
    public var state: TestingState = .unknown
    public var reliabilityStats: ReliabilityStats?

    
    public init(name: String, block: @escaping () async throws -> Void) {
        self.name = name
        self.block = block
    }
}

@MainActor
public struct ReliabilityStats: Hashable {
    public var successCount: Int = 0
    public var failureCount: Int = 0
    public var totalCount: Int = 0
}
