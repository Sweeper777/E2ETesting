//
//  TestSuiteMacro.swift
//  E2ETesting
//
//  Created by Mulang Su on 20/12/2025.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum TestSuiteMacro: MemberMacro, ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let classDecl = declaration.as(ClassDeclSyntax.self) else {
            throw MacroExpansionErrorMessage("This macro must be attached to a class declaration.")
        }
        let nameExpr = if case let .argumentList(args) = node.arguments, let name = args.first?.expression {
            name
        } else {
            ExprSyntax(StringLiteralExprSyntax(content: classDecl.name.text))
        }
        let nameDecl: DeclSyntax = "static let name: String = \(nameExpr)"
        let testMethodsDecl: DeclSyntax = "var testMethods: [TestMethod] = []"
        
        var testMethodDecls = [FunctionDeclSyntax]()
        var testMethodNameExprs = [ExprSyntax]()
        for member in classDecl.memberBlock.members {
            guard let funcDecl = member.decl.as(FunctionDeclSyntax.self) else { continue }
            let testMethodMacro = funcDecl.attributes.compactMap {
                if case let .attribute(attr) = $0,
                   attr.attributeName.as(IdentifierTypeSyntax.self)?.name.text == "TestMethod" {
                    return attr
                } else {
                    return nil
                }
            }.first
            guard let testMethodMacro else { continue }
            
            let testName = if case let .argumentList(args) = testMethodMacro.arguments, let name = args.first?.expression {
                name
            } else {
                ExprSyntax(StringLiteralExprSyntax(content: funcDecl.name.text))
            }
            testMethodNameExprs.append(testName)
            testMethodDecls.append(funcDecl)
        }
        
        let testMethodNamesArray = ArrayExprSyntax(elementsBuilder: {
            for name in testMethodNameExprs {
                ArrayElementSyntax(expression: name)
            }
        })
        
        let testMethodNamesDecl: DeclSyntax = "static let testMethodNames: [String] = \(testMethodNamesArray)"
        
        let testMethodsArray = ArrayExprSyntax(elementsBuilder: {
            for (testMethodDecl, name) in zip(testMethodDecls, testMethodNameExprs) {
                ArrayElementSyntax(expression: """
                TestMethod(name: \(name)) { [unowned self] in
                    try await self.\(testMethodDecl.name)() 
                }
                """ as ExprSyntax)
            }
        })
        
        let initDecl = DeclSyntax(InitializerDeclSyntax(signature: .init(parameterClause: .init {})) {
            "testMethods = \(testMethodsArray)"
        })
        return [nameDecl, testMethodsDecl, testMethodNamesDecl, initDecl]
    }
    
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let typeName = type.as(IdentifierTypeSyntax.self)?.name
        return [
            try ExtensionDeclSyntax("extension \(typeName): TestSuite") {}
        ]
    }
}

enum TestMethodMacro: PeerMacro {
    static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let funcDecl = declaration.as(FunctionDeclSyntax.self) else {
            throw MacroExpansionErrorMessage("This macro can only be attached to methods")
        }
        if let staticModifier = funcDecl.modifiers.first(where: { $0.name.text == "static" }) {
            context.addDiagnostics(from: MacroExpansionErrorMessage("Test methods cannot be static"), node: staticModifier)
        }
        if !funcDecl.signature.parameterClause.parameters.isEmpty {
            context.addDiagnostics(from: MacroExpansionErrorMessage("Test methods cannot have parameters"), node: funcDecl.signature.parameterClause.parameters)
        }
        if funcDecl.signature.effectSpecifiers?.asyncSpecifier == nil ||
            funcDecl.signature.effectSpecifiers?.throwsClause == nil {
            context.addDiagnostics(from: MacroExpansionErrorMessage("Test methods must be async throws"), node: funcDecl)
        }
        return []
    }
}
