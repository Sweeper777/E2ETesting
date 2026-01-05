//
//  TestSuite.swift
//  E2ETesting
//
//  Created by Mulang Su on 20/12/2025.
//

@MainActor
public protocol TestSuite: AnyObject {
    func setUp() async throws
    func tearDown() async throws
    var testMethods: [TestMethod] { get }
    static var name: String { get }
    static var testMethodNames: [String] { get }
    
    init()
}

public extension TestSuite {
    func setUp() async throws {}
    func tearDown() async throws {}
}
