//
//  TestingContext.swift
//  E2ETesting
//
//  Created by Mulang Su on 20/12/2025.
//

import Observation

@MainActor
public enum TestingContext {
    public internal(set) static var currentTestMethod: TestMethod?
}
