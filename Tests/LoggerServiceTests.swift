//
//  LogCategory.swift
//  LoggingKit
//
//  Created by Petter vang Brakalsvålet on 16/10/2024.
//

import Testing
@testable import LoggingKit

extension LogCategory {
    static let mock = LogCategory("mock")
    static let mock1 = LogCategory("mock1")
    static let mock2 = LogCategory("mock2")
    static let mock3 = LogCategory("mock3")
}

@Suite("Test logging service")
struct LoggerServiceTests {
    
    @Test("Test logging creation", arguments: [LogCategory.mock, .mock1, .mock2, .mock3])
    func testLoggingCreation(category: LogCategory) async throws {
        let sut = LoggerService(subsystem: "com.braka.test")
        sut.log(category: category, message: "Test message", error: nil, level: .debug)
        #expect(sut.loggers[category] != nil)
    }
}
