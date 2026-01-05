import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum AssertMacro: ExpressionMacro {
    static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let macroName = node.macroName.identifier?.name else {
            throw MacroExpansionErrorMessage("Unable to identify macro")
        }
        let targetMethodName = "_" + macroName
        var args: [ExprSyntax] = []
        for macroArg in node.arguments {
            if macroArg.label == nil {
                args.append(macroArg.expression)
                args.append(
                    ExprSyntax(StringLiteralExprSyntax(content: macroArg.expression.trimmedDescription))
                )
            } else {
                args.append(macroArg.expression)
            }
        }
        let argList = LabeledExprListSyntax {
            for arg in args {
                LabeledExprSyntax(expression: arg)
            }
        }
        return "try \(raw: targetMethodName)(\(argList))"
    }
}
