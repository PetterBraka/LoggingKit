//
//  LoggerServicing.swift
//  LoggingKit
//
//  Created by Petter vang Brakalsvålet on 16/10/2024.
//

public protocol LoggerServicing {
    
    /// Enable logging for specific categories
    func enable(_ categories: LogCategory...)
    
    /// Disable logging for specific categories
    func disable(_ categories: LogCategory...)
    
    /// Set logging level
    func set(levels: LogLevel...)
    
    /// Sends a message to the console
    func log(category: LogCategory, message: String, error: Error?, level: LogLevel)
}
