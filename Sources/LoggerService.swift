//
//  LoggerService.swift
//  LoggingKit
//
//  Created by Petter vang Brakalsvålet on 16/10/2024.
//

import OSLog

public final class LoggerService: LoggerServicing {
    private let subsystem: String
    internal private(set) var loggers: [LogCategory: Logger]
    internal private(set) var enabledCategories: Set<LogCategory>
    
    public init(subsystem: String) {
        self.subsystem = subsystem
        self.loggers = [:]
        self.enabledCategories = []
    }
    
    public func enable(_ categories: LogCategory...) {
        for category in categories {
            enabledCategories.insert(category)
        }
    }
    
    public func disable(_ categories: LogCategory...) {
        for category in categories {
            enabledCategories.remove(category)
        }
    }
    
    public func log(category: LogCategory, message: String, error: Error?, level: LogLevel) {
        guard enabledCategories.contains(category) else { return }
        
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
