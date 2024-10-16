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
    let subsystem = "com.braka.test"
    
    @Test("Test logging for enabled categories", arguments: [LogCategory.mock, .mock1, .mock2, .mock3])
    func testEnablingLogging(for category: LogCategory) {
        let sut = LoggerService(subsystem: subsystem)
        sut.enable(category)
        sut.log(category: category, message: "Test message", error: nil, level: .debug)
        
        #expect(sut.enabledCategories == [category])
        #expect(sut.loggers.keys.map { $0 } == [category])
    }
    
    @Test("Test logging for disabled categories", arguments: [LogCategory.mock, .mock1, .mock2, .mock3])
    func testDisablingLogging(for category: LogCategory) {
        let sut = LoggerService(subsystem: subsystem)
        sut.disable(category)
        sut.log(category: category, message: "Test message", error: nil, level: .debug)
        
        #expect(sut.enabledCategories != [category])
        #expect(sut.loggers.keys.map { $0 } != [category])
    }
    
    @Test("Test enabling multiple categories")
    func testEnablingMultipleCategories() async throws {
        let sut = LoggerService(subsystem: subsystem)
        sut.enable(.mock, .mock1, .mock2, .mock3)
        
        #expect(sut.enabledCategories == [.mock, .mock1, .mock2, .mock3])
    }
    
    @Test("Test disabling multiple categories")
    func testDisablinggMultipleCategories() async throws {
        let sut = LoggerService(subsystem: subsystem)
        sut.enable(.mock, .mock1, .mock2, .mock3)
        
        #expect(sut.enabledCategories == [.mock, .mock1, .mock2, .mock3])
        
        sut.disable(.mock1, .mock3)
        #expect(sut.enabledCategories == [.mock, .mock2])
    }
}
