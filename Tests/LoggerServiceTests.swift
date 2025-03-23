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
    
    @Test("Test logging", arguments: [LogCategory.mock, .mock1, .mock2, .mock3])
    func testLogging(for category: LogCategory) async {
        let sut = LoggerService(subsystem: subsystem)
        await sut.log(category: category, message: "Test message", error: nil, level: .debug)
        
        await #expect(sut.enabledCategories == [.default])
        await #expect(sut.loggers.keys.map { $0 } == [category])
    }
    
    @Test("Test logging for enabling categories", arguments: [LogCategory.mock, .mock1, .mock2, .mock3])
    func testEnablingLogging(for category: LogCategory) async {
        let sut = LoggerService(subsystem: subsystem)
        await sut.enable(category)
        await sut.log(category: category, message: "Test message", error: nil, level: .debug)
        
        await #expect(sut.enabledCategories == [category])
        await #expect(sut.loggers.keys.map { $0 } == [category])
    }
    
    @Test("Test logging for disabled categories", arguments: [LogCategory.mock, .mock1, .mock2, .mock3])
    func testDisablingLogging(for category: LogCategory) async {
        let sut = LoggerService(subsystem: subsystem)
        await sut.disable(category)
        await sut.log(category: category, message: "Test message", error: nil, level: .debug)
        
        await #expect(sut.enabledCategories != [category])
        await #expect(sut.loggers.keys.map { $0 } != [category])
    }
    
    @Test("Test enabling multiple categories")
    func testEnablingMultipleCategories() async throws {
        let sut = LoggerService(subsystem: subsystem)
        await sut.enable(.mock, .mock1, .mock2, .mock3)
        
        await #expect(sut.enabledCategories == [.mock, .mock1, .mock2, .mock3])
    }
    
    @Test("Test disabling multiple categories")
    func testDisablinggMultipleCategories() async throws {
        let sut = LoggerService(subsystem: subsystem)
        await sut.enable(.mock, .mock1, .mock2, .mock3)
        
        await #expect(sut.enabledCategories == [.mock, .mock1, .mock2, .mock3])
        
        await sut.disable(.mock1, .mock3)
        await #expect(sut.enabledCategories == [.mock, .mock2])
    }
    
    @Test("Test logging with set level", arguments: [LogLevel.info, .debug, .default, .fault, .error])
    func testSettingLogLevel(for level: LogLevel) async {
        let sut = LoggerService(subsystem: subsystem)
        await sut.set(levels: level)
        await sut.log(category: .mock, message: "Test message", error: nil, level: level)
        
        await #expect(sut.loggers.keys.map { $0 } == [.mock])
    }
    
    @Test("Test logging with set levels")
    func testSettingLogLevels() async {
        let sut = LoggerService(subsystem: subsystem)
        await sut.set(levels: .info)
        await sut.log(category: .mock, message: "Test message", error: nil, level: .debug)
        await #expect(sut.loggers.keys.map { $0 } != [.mock])
        
        await sut.set(levels: .debug, .default)
        await sut.log(category: .mock, message: "Test message", error: nil, level: .info)
        await #expect(sut.loggers.keys.map { $0 } != [.mock])
        
    }
}
