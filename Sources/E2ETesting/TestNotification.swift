//
//  TestNotification.swift
//  E2ETesting
//
//  Created by Mulang Su on 21/12/2025.
//

import Foundation

public enum TestNotification {
    public static let didStartSuite: Notification.Name = .init("E2ETesting.didStartSuite")
    public static let didEndSuite: Notification.Name = .init("E2ETesting.didEndSuite")
    public static let didStartMethod: Notification.Name = .init("E2ETesting.didStartMethod")
    public static let didEndMethod: Notification.Name = .init("E2ETesting.didEndMethod")
    public static let suiteKey = "E2ETesting.TestSuite"
    public static let testMethodKey = "E2ETesting.TestMethod"
    
    static func postStart(_ suite: any TestSuite) {
        NotificationCenter.default.post(name: didStartSuite, object: nil, userInfo: [suiteKey: suite])
    }
    static func postEnd(_ suite: any TestSuite) {
        NotificationCenter.default.post(name: didEndSuite, object: nil, userInfo: [suiteKey: suite])
    }
    
    static func postStart(_ method: TestMethod) {
        NotificationCenter.default.post(name: didStartMethod, object: nil, userInfo: [testMethodKey: method])
    }
    static func postEnd(_ method: TestMethod) {
        NotificationCenter.default.post(name: didEndMethod, object: nil, userInfo: [testMethodKey: method])
    }
}
