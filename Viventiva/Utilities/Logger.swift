//
//  Logger.swift
//  Viventiva
//
//  Centralized logging utility for better debugging
//

import Foundation
import OSLog

enum LogLevel {
    case debug
    case info
    case warning
    case error
}

struct AppLogger {
    private static let logger = Logger(subsystem: "com.viventiva.app", category: "App")
    
    static func log(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[\(fileName):\(line)] \(function) - \(message)"
        
        switch level {
        case .debug:
            logger.debug("\(logMessage)")
            #if DEBUG
            print("🔍 DEBUG: \(logMessage)")
            #endif
        case .info:
            logger.info("\(logMessage)")
            #if DEBUG
            print("ℹ️ INFO: \(logMessage)")
            #endif
        case .warning:
            logger.warning("\(logMessage)")
            print("⚠️ WARNING: \(logMessage)")
        case .error:
            logger.error("\(logMessage)")
            print("❌ ERROR: \(logMessage)")
        }
    }
    
    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }
    
    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }
    
    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, file: file, function: function, line: line)
    }
    
    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }
}

