//
//  ExampleMacro.swift
//  E2ETesting
//
//  Created by Mulang Su on 21/12/2025.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum ExampleMacro: MemberMacro {
    static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        [
            """
            func testFoo() {
            
            }
            """
        ]
    }
}
