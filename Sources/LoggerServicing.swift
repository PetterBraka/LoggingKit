//
//  LoggerServicing.swift
//  LoggingKit
//
//  Created by Petter vang Brakalsvålet on 16/10/2024.
//

public protocol LoggerServicing {
    
    /// Enable logging for specific categories
    func enable(_ categories: LogCategory...) async
    
    /// Disable logging for specific categories
    func disable(_ categories: LogCategory...) async
    
    /// Set logging level
    func set(levels: LogLevel...) async
    
    /// Sends a message to the console
    func log(category: LogCategory, message: String, error: Error?, level: LogLevel) async
}
