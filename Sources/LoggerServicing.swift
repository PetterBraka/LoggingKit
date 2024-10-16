//
//  LoggerServicing.swift
//  LoggingKit
//
//  Created by Petter vang Brakalsvålet on 16/10/2024.
//

public protocol LoggerServicing {
    func enable(_ categories: LogCategory...)
    func disable(_ categories: LogCategory...)
    
    func log(category: LogCategory, message: String, error: Error?, level: LogLevel)
}
