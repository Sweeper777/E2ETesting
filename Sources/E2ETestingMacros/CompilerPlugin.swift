//
//  CompilerPlugin.swift
//  E2ETesting
//
//  Created by Mulang Su on 20/12/2025.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct E2ETestingPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AssertMacro.self,
        TestSuiteMacro.self,
        TestMethodMacro.self,
        MeasureMacro.self,
    ]
}
