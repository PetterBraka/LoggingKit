//
//  LogCategory.swift
//  LoggingKit
//
//  Created by Petter vang Brakalsvålet on 16/10/2024.
//

public struct LogCategory: Sendable, Hashable {
    public let name: String
    
    public init(_ name: String) {
        self.name = name
    }
}
