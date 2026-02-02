//
//  MeasureMacro.swift
//  E2ETesting
//
//  Created by Mulang Su on 21/12/2025.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum MeasureMacro: ExpressionMacro {
    static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let measurementName = node.arguments.first?.expression else {
            throw MacroExpansionErrorMessage("Missing measurement name")
        }
        let closure = if let secondArg = node.arguments.dropFirst().first?.expression.as(ClosureExprSyntax.self) {
            secondArg
        } else if let trailingCLosure = node.trailingClosure {
            trailingCLosure
        } else {
            throw MacroExpansionErrorMessage("Missing closure")
        }
        let closureString = closure.statements.map(\.description).joined(separator: "\n").trimIndent()
        let argList = LabeledExprListSyntax {
            LabeledExprSyntax(expression: measurementName)
            LabeledExprSyntax(expression: closure)
            LabeledExprSyntax(expression: StringLiteralExprSyntax(content: closureString))
        }
        return "try await _measure(\(argList))"
    }
}

extension Array where Element: StringProtocol {
    func reindent(
        indentWidth: Int
    ) -> String {
        let lastIndex = count - 1
        return enumerated().compactMap { (index, value) in
            if (index == 0 || index == lastIndex) && value.isBlank {
                String?.none
            } else {
                String(value.dropFirst(indentWidth))
            }
        }
        .joined(separator: "\n")
    }
}



extension StringProtocol {
    var isBlank: Bool {
        allSatisfy { $0.isWhitespace }
    }
    
    private var indentWidth: Int {
        if let index = firstIndex(where: { !$0.isWhitespace }) {
            distance(from: startIndex, to: index)
        } else {
            count
        }
    }
    
    func trimIndent() -> String {
        let lines = split(separator: "\n")
        let minCommonIndent = lines
            .filter { !$0.isBlank }
            .map(\.indentWidth)
            .min() ?? 0
        return lines.reindent(
            indentWidth: minCommonIndent
        )
    }
}
