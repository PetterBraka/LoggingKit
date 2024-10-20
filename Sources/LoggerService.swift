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
    internal private(set) var logLevels: Set<LogLevel>
    internal private(set) var enabledCategories: Set<LogCategory>
    
    public init(subsystem: String) {
        self.subsystem = subsystem
        self.loggers = [:]
        self.logLevels = [.debug, .info, .default, .error, .fault]
        self.enabledCategories = [.default]
    }
    
    public func enable(_ categories: LogCategory...) {
        enabledCategories.remove(.default)
        for category in categories {
            enabledCategories.insert(category)
        }
    }
    
    public func disable(_ categories: LogCategory...) {
        enabledCategories.remove(.default)
        for category in categories {
            enabledCategories.remove(category)
        }
    }
    
    public func set(levels: LogLevel...) {
        logLevels = Set(levels)
    }
    
    public func log(category: LogCategory, message: String, error: Error?, level: LogLevel) {
        guard logLevels.contains(level), (enabledCategories.contains(category) || enabledCategories == [.default])
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
