//
//  TestFailure.swift
//  E2ETesting
//
//  Created by Mulang Su on 20/12/2025.
//

import Foundation

struct TestFailure: LocalizedError, CustomStringConvertible {
    let message: String
    let file: StaticString
    let line: Int
    let column: Int
    
    var description: String {
        "\(message) (\(file) Line \(line):\(column))"
    }
}
