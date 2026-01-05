//
//  TestLog.swift
//  E2ETesting
//
//  Created by Mulang Su on 20/12/2025.
//

import Foundation

public struct TestLog: Hashable, CustomStringConvertible, Identifiable {
    public let timestamp = Date()
    public let severity: LogSeverity
    public let message: String
    public let id = UUID()
    
    public var description: String {
        "[\(timestamp.formatted(.iso8601))] \(severity.prefix)\(message)"
    }
}
