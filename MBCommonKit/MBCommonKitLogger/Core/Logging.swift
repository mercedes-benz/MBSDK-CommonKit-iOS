//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public protocol Logging {
    
    /// specifies queue on which output will be written. Can be modified on init
    var outputQueue: DispatchQueue { get }
    
    /// Format the log output with the given parameters
    ///
    /// Override this function to create your own output format
    ///
    /// - Parameters:
    ///   - level: logLevel
    ///   - items: log message
    ///   - fileName: fileName where the Log is triggered
    ///   - functionName: functionName where the Log is triggered
    ///   - line: line number where the Log is triggered
    /// - Returns: formatted string
    func formatOutputString(level: LogLevel, items: Any?, fileName: String, functionName: String, line: Int) -> String
    
    
    /// Process the current log output.
    ///
    /// - Parameters:
    ///   - level: logLevel (nil -> automated Logs)
    ///   - string: log message
    func writeOutput(level: LogLevel?, string: String)
}
