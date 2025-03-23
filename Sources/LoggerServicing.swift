//
//  LoggerServicing.swift
//  LoggingKit
//
//  Created by Petter vang Brakalsvålet on 16/10/2024.
//

public protocol LoggerServicing: Sendable {
    
    /// Enable logging for specific categories
    nonisolated func enable(_ categories: LogCategory...) async
    
    /// Disable logging for specific categories
    nonisolated func disable(_ categories: LogCategory...) async
    
    /// Set logging level
    nonisolated func set(levels: LogLevel...) async
    
    /// Sends a message to the console
    nonisolated func log(category: LogCategory, message: String, error: Error?, level: LogLevel) async
}
