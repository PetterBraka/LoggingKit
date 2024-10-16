//
//  MappingTests.swift
//  LoggingKit
//
//  Created by Petter vang Brakalsvålet on 16/10/2024.
//

import OSLog
import Testing
@testable import LoggingKit

@Suite("Test mapping of models")
struct MappingTests {
    
    @Test("Test mapping of LogLevel to OSLogType")
    func testLogLevelMapper() {
        #expect(OSLogType.init(from: .default) == .default)
        #expect(OSLogType.init(from: .info) == .info)
        #expect(OSLogType.init(from: .debug) == .debug)
        #expect(OSLogType.init(from: .error) == .error)
        #expect(OSLogType.init(from: .fault) == .fault)
    }
}
