//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

// swiftlint:disable identifier_name
public class MBLogger {
    
    /// Singleton
    public static let shared = MBLogger()
    
    /// Default is .verbose
    ///
    /// Will output logLevels greater than or equal the defined level
    public var logLevel = LogLevel.verbose
    
    /// Will automatically output logs in viewWillAppear (default == true)
    ///
    /// Marked with "🔵"
    public var isUiLoggingEnabled: Bool = true
    
    /// Registered loggers
    public internal(set) var registeredLoggers = [Logging]()
    
    
    // MARK: - Init
    
    private init() {
        UIViewController.startSwizzle()
    }
    
    
    /// Register loggers
    public func register(logger: Logging) {
        self.registeredLoggers.append(logger)
    }
    
    
    // MARK: - LOG level functions
	
    /// Print verbose Logs -> marked with "🚩"
    public func V(_ items: Any?=nil, functionName: String = #function, fileName: String = #file, line: Int = #line) {
        self.dispatchOutput(level: .verbose, items: items, fileName: fileName, functionName: functionName, line: line)
    }
    
    
    /// Print debug Logs -> marked with "🚀"
    public func D(_ items: Any?=nil, functionName: String = #function, fileName: String = #file, line: Int = #line) {
        self.dispatchOutput(level: .debug, items: items, fileName: fileName, functionName: functionName, line: line)
    }
    
    
    /// Print info Logs -> marked with "ℹ️"
    public func I(_ items: Any?=nil, functionName: String = #function, fileName: String = #file, line: Int = #line) {
       self.dispatchOutput(level: .info, items: items, fileName: fileName, functionName: functionName, line: line)
    }
    
    
    /// Print warning Logs -> marked with "⚠️"
    public func W(_ items: Any?=nil, functionName: String = #function, fileName: String = #file, line: Int = #line) {
        self.dispatchOutput(level: .warning, items: items, fileName: fileName, functionName: functionName, line: line)
    }
    
    
    /// Print error Logs -> marked with "⛔️"
    public func E(_ items: Any?=nil, functionName: String = #function, fileName: String = #file, line: Int = #line) {
		self.dispatchOutput(level: .error, items: items, fileName: fileName, functionName: functionName, line: line)
    }
    
    
    // UI Logs
    func U(_ string: String) {
		
        guard self.isUiLoggingEnabled else {
            return
        }
        
        let output = "🔵 | " + string
        
        self.registeredLoggers.forEach { (logger) in
            logger.writeOutput(level: nil, string: output)
        }
    }
    
    
	// MARK: - Output
    
    private func dispatchOutput(level: LogLevel, items: Any?, fileName: String, functionName: String, line: Int) {
        
        guard self.logLevel <= level else {
            return
        }
        
        self.registeredLoggers.forEach { (logger) in
            
            let formattedString = logger.formatOutputString(level: level, items: items, fileName: fileName, functionName: functionName, line: line)
            logger.writeOutput(level: level, string: formattedString)
        }
    }
}
// swiftlint:enable identifier_name
