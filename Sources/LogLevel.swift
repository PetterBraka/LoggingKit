//
//  LogLevel.swift
//  LoggingKit
//
//  Created by Petter vang Brakalsvålet on 16/10/2024.
//

import OSLog

public enum LogLevel: Sendable {
    case `default`
    case info
    case debug
    case error
    case fault
}

extension OSLogType {
    init(from level: LogLevel) {
        self = switch level {
        case .default: .default
        case .info: .info
        case .debug: .debug
        case .error: .error
        case .fault: .fault
        }
    }
}
