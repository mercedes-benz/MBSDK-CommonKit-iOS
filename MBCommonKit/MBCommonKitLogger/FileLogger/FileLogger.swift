//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit


/// FileLogger stores two log-files to the documents directory
///
/// One file for the current session and one for the previous session
public class FileLogger: Logging {
    
    // MARK: - Properties
    
    public static let logFile = LogFile.self
    
    private var fileManager = FileManager.default
    private var fileHandle: FileHandle?
    
    private lazy var dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
    
    public let outputQueue: DispatchQueue
    
    // MARK: - Init
    
    public init(outputQueue: DispatchQueue = .defaultLoggingQueue()) {
        self.outputQueue = outputQueue
        self.prepareFiles()
        self.redirectLogToDocuments()
        self.addHeaderLog()
    }
    
    deinit {
        self.closeFileHandle()
    }
    
    // MARK: - Protocol conformance
    
    public func formatOutputString(level: LogLevel, items: Any?, fileName: String, functionName: String, line: Int) -> String {
        
        let date = self.dateFormatter.string(from: Date())
        var output = "\(date) | \(level.emoji) | "
        
        if let nameComps = URL(string: fileName)?.lastPathComponent.components(separatedBy: "."), nameComps.count > 0 {
            output += "\(nameComps[0]) | "
        }
        
        output += "\(functionName) | \(line) | "
        
        if let out = items {
            output += "\n→ \(out)"
        }
        
        return output
    }
    
    
    public func writeOutput(level: LogLevel?, string: String) {
        self.outputQueue.async {
            self.writeToFile(string: string)
        }
    }
    
    
    // MARK: - File Handling
    
    func writeToFile(string: String) {
        guard let fileHandle = self.fileHandle else {
            return
        }
        
        if #available(iOS 13.0, *) {
            writeToFileIOS13(fileHandle: fileHandle, string: string)
        } else {
            writeToFileLegacy(fileHandle: fileHandle, string: string)
        }
    }
    
    @available(iOS 13.0, *)
    private func writeToFileIOS13(fileHandle: FileHandle, string: String) {
        do {
            _ = try fileHandle.__seek(toEndReturningOffset: nil)
            
            let line = string + "\n"
            
            guard let data = line.data(using: String.Encoding.utf8) else {
                return
            }
            
            try fileHandle.__write(data, error: ())
            try fileHandle.synchronize()
        } catch {
            // cant write file log
            // do not affect app experience in any way
        }
    }
    
    private func closeFileHandle() {
        if #available(iOS 13.0, *) {
            try? self.fileHandle?.close()
        } else {
            self.closeFileHandleLegacy()
        }
    }
    
    private func prepareFiles() {
        
        // create "Logs"-directory if needed
        try? self.fileManager.createDirectory(atPath: FilePath.directory.path, withIntermediateDirectories: false, attributes: nil)
        
        // remove prev session
        try? self.fileManager.removeItem(atPath: LogFile.previous.path)
        
        // copy current session as prev session
        try? self.fileManager.moveItem(atPath: LogFile.current.path, toPath: LogFile.previous.path)
        
        // create logfile for current session
        self.fileManager.createFile(atPath: LogFile.current.path, contents: nil, attributes: nil)
        
        self.fileHandle = try? FileHandle(forWritingTo: LogFile.current.url)
    }
    
    private func redirectLogToDocuments() {
        
        if self.isDebbugingInProcess() {
            return
        }
        
        let pathForCurrentLog = LogFile.current.path
        freopen(pathForCurrentLog.cString(using: String.Encoding.ascii)!, "a+", stderr)
	}
    
    private func addHeaderLog() {
        
        self.writeOutput(level: nil, string: "------------------------------")
        self.writeOutput(level: nil, string: "ℹ️ Device:  \(UIDevice.modelName)")
        self.writeOutput(level: nil, string: "ℹ️ App:     \(Bundle.main.bundleAppDisplayName())")
        self.writeOutput(level: nil, string: "ℹ️ Version: \(Bundle.main.bundleShortVersion())")
        self.writeOutput(level: nil, string: "ℹ️ Build:   \(Bundle.main.bundleBuildVersion())")
        self.writeOutput(level: nil, string: "ℹ️ iOS:     \(UIDevice.current.systemVersion)")
        self.writeOutput(level: nil, string: "------------------------------")
    }
    
    
    // MARK: - Helper
    
    private func isDebbugingInProcess() -> Bool {
        
        var info = kinfo_proc()
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout.stride(ofValue: info)
        let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        assert(junk == 0, "sysctl failed")
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }
	
	
	// MARK: - Deprecated
	
	@available(iOS, deprecated: 13.0, message: "uses deprecated FileHandle APIs")
    private func writeToFileLegacy(fileHandle: FileHandle, string: String) {
        _ = fileHandle.seekToEndOfFile()
        let line = string + "\n"
        
        guard let data = line.data(using: String.Encoding.utf8) else {
            return
        }
        
        fileHandle.write(data)
        fileHandle.synchronizeFile()
    }
	
    @available(iOS, deprecated: 13.0, message: "uses deprecated FileHandle APIs")
    private func closeFileHandleLegacy() {
        self.fileHandle?.closeFile()
    }
}
