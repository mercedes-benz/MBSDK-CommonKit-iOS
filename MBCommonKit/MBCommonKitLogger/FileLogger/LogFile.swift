//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public enum LogFile {
    
    case current
    case previous
    
    /// FilePath to Directory
    public var path: String {
        
        switch self {
        case .current:
            return FilePath.current.path
        case .previous:
            return FilePath.previous.path
        }
    }
    
    /// File URL
    public var url: URL {
        return URL(fileURLWithPath: self.path)
    }
    
    /// Stored data
    public var data: Data? {
        return try? Data(contentsOf: self.url)
    }
    
    /// Get last n-bytes from the Log-file
    public func getLatestLog(withBytes maxSize: Int) -> String? {
        
        guard let data = self.data else {
            return nil
        }
        
        guard let string = String(data: data, encoding: String.Encoding.utf8) else {
            return nil
        }
        
        if string.lengthOfBytes(using: String.Encoding.utf8) > maxSize {
            
            let index = string.index(string.endIndex, offsetBy: -maxSize)
            let substring = string[index...]
            return String(substring)
        }
        
        return string
    }
}

enum FilePath {
    
    case directory
    case current
    case previous
    
    var path: String {
        
        var string = ""
        
        switch self {
        case .directory:
            string = "/Logs"
        case .current:
            string = "/Logs/current_session.log"
        case .previous:
            string = "/Logs/prev_session.log"
        }
        
        let searchPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentFolderPath = searchPaths[0]
        
        let filePath = (documentFolderPath as NSString).appendingPathComponent(string)
        return filePath
    }
}
