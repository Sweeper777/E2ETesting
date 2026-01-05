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
    
    public init(name: String, block: @escaping () async throws -> Void) {
        self.name = name
        self.block = block
    }
}
