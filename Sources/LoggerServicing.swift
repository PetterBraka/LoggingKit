//
//  LoggerServicing.swift
//  LoggingKit
//
//  Created by Petter vang Brakalsvålet on 16/10/2024.
//

public protocol LoggerServicing {
    func log(category: LogCategory, message: String, error: Error?, level: LogLevel)
}
