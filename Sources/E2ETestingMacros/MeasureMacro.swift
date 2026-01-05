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
        let closureString = closure.statements.map(\.trimmedDescription).joined(separator: "\n")
        let argList = LabeledExprListSyntax {
            LabeledExprSyntax(expression: measurementName)
            LabeledExprSyntax(expression: closure)
            LabeledExprSyntax(expression: StringLiteralExprSyntax(content: closureString))
        }
        return "try await _measure(\(argList))"
    }
}
