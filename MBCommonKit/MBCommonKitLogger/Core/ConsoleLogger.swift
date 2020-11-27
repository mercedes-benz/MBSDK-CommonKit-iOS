//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public class ConsoleLogger: Logging {
    
    // MARK: - Properties
    
    private lazy var dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
    
    public let outputQueue: DispatchQueue
    
    // MARK: - Init
    
    public init(outputQueue: DispatchQueue = .defaultLoggingQueue()) {
        self.outputQueue = outputQueue
    }
    
    
    // MARK: - Protocol Conformance
    
    public func formatOutputString(level: LogLevel, items: Any?, fileName: String, functionName: String, line: Int) -> String {
        
        let date = self.dateFormatter.string(from: Date())
        var output = "\(date) | \(level.emoji) | "
        
        if let nameComps = URL(string: fileName)?.lastPathComponent.components(separatedBy: "."), nameComps.count > 0 {
            output += "\(nameComps[0]) | "
        }
        
        output += "\(functionName) | \(line) | "
        
        if let out = items {
            output += "\(out)"
        }
        
        return output
    }
    
    
    public func writeOutput(level: LogLevel?, string: String) {
        self.outputQueue.async {
            print(string)
        }
    }
}
