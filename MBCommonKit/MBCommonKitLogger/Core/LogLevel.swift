//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public enum LogLevel: Int {
    
    case verbose
    case debug
    case info
    case warning
    case error
    
    public var emoji: String {
        
        switch self {
        case .verbose:  return "🚩"
        case .debug:    return "🚀"
        case .info:     return "ℹ️"
        case .warning:  return "⚠️"
        case .error:    return "⛔️"
        }
    }
    
    static func <= (a: LogLevel, b: LogLevel) -> Bool {
        return a.rawValue <= b.rawValue
    }
}
