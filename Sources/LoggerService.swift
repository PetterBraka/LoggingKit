//
//  LoggerService.swift
//  LoggingKit
//
//  Created by Petter vang Brakalsvålet on 16/10/2024.
//

import OSLog

public final actor LoggerService {
    private let subsystem: String
    internal private(set) var loggers: [LogCategory: Logger]
    internal private(set) var logLevels: Set<LogLevel>
    internal private(set) var enabledCategories: Set<LogCategory>
    
    public init(subsystem: String, levels: Set<LogLevel> = .default, categories: Set<LogCategory> = .default) {
        self.subsystem = subsystem
        self.loggers = [:]
        self.logLevels = levels
        self.enabledCategories = categories
    }
}

extension LoggerService: LoggerServicing {
    nonisolated public func enable(_ categories: LogCategory...) {
        Task { await self._enable(categories) }
    }
    
    nonisolated public func disable(_ categories: LogCategory...) {
        Task { await self._disable( categories) }
    }
    
    nonisolated public func set(levels: LogLevel...) {
        Task { await self._set(levels: levels) }
    }
    
    nonisolated public func log(category: LogCategory, message: String, error: Error?, level: LogLevel) {
        Task { await self._log(category: category, message: message, error: error, level: level) }
    }
}

private extension LoggerService {
    func _enable(_ categories: [LogCategory]) async {
        enabledCategories.removeAll()
        for category in categories {
            enabledCategories.insert(category)
        }
    }
    
    func _disable(_ categories: [LogCategory]) async {
        for category in categories {
            enabledCategories.remove(category)
        }
    }
    
    func _set(levels: [LogLevel]) async {
        logLevels = Set(levels)
    }
    
    func _log(category: LogCategory, message: String, error: Error?, level: LogLevel) async {
        guard logLevels.contains(level),
              enabledCategories.contains(category)
        else { return }
        
        let logger: Logger
        if let oldLogger = loggers[category] {
            logger = oldLogger
        } else {
            let newLogger = Logger(subsystem: subsystem, category: category.name)
            loggers[category] = newLogger
            logger = newLogger
        }
        
        if let error {
            logger.log(level: .init(from: level), "\(message) -Error: \(error)")
        } else {
            logger.log(level: .init(from: level), "\(message)")
        }
    }
}
