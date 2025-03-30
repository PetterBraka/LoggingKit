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

struct DummyError: Error {}

@Suite("Test logging service")
struct LoggerServiceTests {
    let subsystem = "com.braka.test"
    let waitTimeout = 0.5
    
    @Test("Test logging", arguments: [LogCategory.mock, .mock1, .mock2, .mock3])
    func testLogging(for category: LogCategory) async {
        let sut = LoggerService(subsystem: subsystem, levels: .default, categories: .default)
        try? await Task.sleep(for: .seconds(waitTimeout))
        sut.log(category: category, message: "Test message", error: nil, level: .debug)
        
        try? await Task.sleep(for: .seconds(waitTimeout))
        await #expect(sut.enabledCategories == [.default])
        await #expect(sut.loggers.keys.map { $0 } != [category])
    }
    
    @Test("Test logging for enabling categories", arguments: [LogCategory.mock, .mock1, .mock2, .mock3])
    func testEnablingLogging(for category: LogCategory) async {
        let sut = LoggerService(subsystem: subsystem, levels: .default, categories: [category])
        sut.log(category: category, message: "Test message", error: nil, level: .debug)
        
        try? await Task.sleep(for: .seconds(waitTimeout))
        await #expect(sut.enabledCategories == [category])
        await #expect(sut.loggers.keys.map { $0 } == [category])
    }
    
    @Test("Test logging for disabled categories", arguments: [LogCategory.mock, .mock1, .mock2, .mock3])
    func testDisablingLogging(for category: LogCategory) async {
        let sut = LoggerService(subsystem: subsystem, levels: .default, categories: [category])
        sut.disable(category)
        try? await Task.sleep(for: .seconds(waitTimeout))
        sut.log(category: category, message: "Test message", error: nil, level: .debug)
        
        try? await Task.sleep(for: .seconds(waitTimeout))
        await #expect(sut.enabledCategories != [category])
        await #expect(sut.loggers.keys.map { $0 } != [category])
    }
    
    @Test("Test enabling multiple categories")
    func testEnablingMultipleCategories() async throws {
        let sut = LoggerService(subsystem: subsystem, levels: .default, categories: .default)
        sut.enable(.mock, .mock1, .mock2, .mock3)
        
        try? await Task.sleep(for: .seconds(waitTimeout))
        await #expect(sut.enabledCategories == [.mock, .mock1, .mock2, .mock3])
    }
    
    @Test("Test disabling multiple categories")
    func testDisablingMultipleCategories() async throws {
        let sut = LoggerService(subsystem: subsystem, levels: .default, categories: [.mock, .mock1, .mock2, .mock3])
        
        try? await Task.sleep(for: .seconds(waitTimeout))
        await #expect(sut.enabledCategories == [.mock, .mock1, .mock2, .mock3])
        
        sut.disable(.mock1, .mock3)
        try? await Task.sleep(for: .seconds(waitTimeout))
        await #expect(sut.enabledCategories == [.mock, .mock2])
    }
    
    @Test("Test logging with set level", arguments: [LogLevel.info, .debug, .default, .fault, .error])
    func testSettingLogLevel(for level: LogLevel) async {
        let sut = LoggerService(subsystem: subsystem, levels: [level], categories: .default)
        sut.set(levels: level)
        try? await Task.sleep(for: .seconds(waitTimeout))
        sut.log(category: .default, message: "Test message", error: nil, level: level)
        
        try? await Task.sleep(for: .seconds(waitTimeout))
        await #expect(sut.loggers.keys.map { $0 } == [.default])
    }
    
    @Test("Test logging with set levels")
    func testSettingLogLevels() async {
        let sut = LoggerService(subsystem: subsystem, levels: .default, categories: .default)
        sut.set(levels: .info)
        try? await Task.sleep(for: .seconds(waitTimeout))
        sut.log(category: .mock, message: "Test message", error: nil, level: .debug)
        try? await Task.sleep(for: .seconds(waitTimeout))
        await #expect(sut.loggers.keys.map { $0 } != [.mock])
        
        sut.set(levels: .debug, .default)
        sut.log(category: .mock, message: "Test message", error: nil, level: .info)
        try? await Task.sleep(for: .seconds(waitTimeout))
        await #expect(sut.loggers.keys.map { $0 } != [.mock])
    }
    
    @Test("Test logging with error")
    func testErrors() async {
        let sut = LoggerService(subsystem: subsystem, levels: .default, categories: .default)
        sut.log(category: .default, message: "Test message", error: DummyError(), level: .error)
        
        try? await Task.sleep(for: .seconds(waitTimeout))
        await #expect(sut.loggers.keys.map { $0 } == [.default])
    }
    
    @Test("Test logging multiple times")
    func testLoggingMultipleTimes() async {
        let sut = LoggerService(subsystem: subsystem, levels: .default, categories: .default)
        sut.log(category: .default, message: "Something is going wrong soon", error: nil, level: .debug)
        try? await Task.sleep(for: .seconds(waitTimeout))
        sut.log(category: .default, message: "Test message", error: DummyError(), level: .error)
        
        try? await Task.sleep(for: .seconds(waitTimeout))
        await #expect(sut.loggers.keys.map { $0 } == [.default])
    }
}
