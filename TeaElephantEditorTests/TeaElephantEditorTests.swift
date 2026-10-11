//
//  TeaElephantEditorTests.swift
//  TeaElephantEditorTests
//
//  Created by Andrew Khasanov on 12.01.2021.
//

import XCTest
import SwiftUI
import Apollo
@testable import TeaElephantEditor

class TeaElephantEditorTests: XCTestCase {

    func testAdminAuthorizationInterceptorAddsBearerToken() async throws {
        let interceptor = AuthInterceptor(tokenProvider: { "synthetic-admin-token" })
        let request = URLRequest(url: URL(string: "https://example.invalid/graphql")!)
        do {
            _ = try await interceptor.intercept(request: request) { request in
                XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer synthetic-admin-token")
                throw InterceptorProbe.requestCaptured
            }
            XCTFail("Expected the test transport to stop the request")
        } catch InterceptorProbe.requestCaptured {}
    }

    func testAdminAuthorizationInterceptorLeavesAnonymousRequestsWithoutToken() async throws {
        let interceptor = AuthInterceptor(tokenProvider: { nil })
        let request = URLRequest(url: URL(string: "https://example.invalid/graphql")!)
        do {
            _ = try await interceptor.intercept(request: request) { request in
                XCTAssertNil(request.value(forHTTPHeaderField: "Authorization"))
                throw InterceptorProbe.requestCaptured
            }
            XCTFail("Expected the test transport to stop the request")
        } catch InterceptorProbe.requestCaptured {}
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testColorHexRoundTrip() throws {
        let expected = "#FF336699"
        let color = Color(hex: expected)
        XCTAssertEqual(color.hex(), expected)
    }

}

private enum InterceptorProbe: Error {
    case requestCaptured
}
