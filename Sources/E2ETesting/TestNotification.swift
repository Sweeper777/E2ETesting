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
    public static let suiteKey = "E2ETesting.TestSuite"
    
    static func postStart(_ suite: any TestSuite) {
        NotificationCenter.default.post(name: didStartSuite, object: nil, userInfo: [suiteKey: suite])
    }
    static func postEnd(_ suite: any TestSuite) {
        NotificationCenter.default.post(name: didEndSuite, object: nil, userInfo: [suiteKey: suite])
    }
}
