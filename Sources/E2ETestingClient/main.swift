import E2ETesting
import Network
import Markdown
import Foundation
import XCTest

@TestSuite("My Tests")
@MainActor
final class MyTests {
    
    @TestMethod("Success Test")
    func success() async throws {
        log("Calculating 1 + 1")
        #assertEqual(1 + 1, 2, stopIfFail: false)
    }
    
    @TestMethod("Failure Test")
    func fail() async throws {
        log("Calculating 1 + 1")
        #assertEqual(1 + 1, 3, stopIfFail: false)
        #assertEqual(1 + 4, 4, stopIfFail: false)
        #assertEqual(1 + 1 + 1, 5, stopIfFail: false)
    }
    
    @TestMethod("Expectation Test")
    func expectations() async throws {
        let conn = NWConnection(host: "127.0.0.1", port: 8554, using: .tcp)
        let expectation1 = Expectation(name: "Connection state becomes ready")
        conn.stateUpdateHandler = { state in
            if state == .ready {
                expectation1.fulfill()
            }
        }
        conn.start(queue: .global())
        let expectation2 = Expectation(name: "`Task.sleep` wakes up")
        Task {
            try await Task.sleep(for: .seconds(0.5))
            expectation2.fulfill()
        }
        
        try await fulfilment(of: [expectation1, expectation2], timeout: 1, stopIfFail: true)
    }
    
    @TestMethod
    func measurement() async throws {
        #measure("Some Time-consuming Operation") {
            try await Task.sleep(for: .seconds(0.2))
            try await Task.sleep(for: .seconds(0.2))
            if Bool.random() {
                print("Foo")
            }
            try await Task.sleep(for: .seconds(0.2))
        }
    }
    
    @TestMethod
    func sequences() async throws {
        let array = [1,2,3]
        #assertContains(array, 1, stopIfFail: false)
        #assertContains(array, 4, stopIfFail: false)
        #assertNotContains(array, 1, stopIfFail: false)
        #assertNotContains(array, 4, stopIfFail: false)
    }
    
    @TestMethod
    func alreadyFulfilledExpectation() async throws {
        let expectation = Expectation(name: "Already Fulfilled")
        await expectation.fulfillIsolated()
        try await fulfilment(of: [expectation], timeout: 10, stopIfFail: false)
    }
}

let report = try await TestRunner.run(MyTests.self, methodName: "alreadyFulfilledExpectation")
//try report.makeMarkdown().format().data(using: .utf8)!.write(to: URL(filePath: "/Users/mulangsu/Desktop/report.md"))
