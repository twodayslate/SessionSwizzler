//
//  FileRecordSaver.swift
//  swizzler
//
//  Created by Zachary Gorak on 6/25/19.
//  Copyright © 2019 Zachary Gorak. All rights reserved.
//

import Foundation

/** A rudamentary CSV-like Saver */
class FileRecordSaver: RecordSaver {
    var filePath: String
    var fm = FileManager.default
    
    init?(name: String) {
        self.filePath = NSString.path(withComponents: [Bundle.main.bundlePath, name]) as String
        
        guard fm.createFile(atPath: self.filePath, contents: nil, attributes: nil) else {
            return nil
        }
        print("Swizzler output path", self.filePath)
    }
    
    func save(record: Record, completion block: ((Error?)->Void)? = nil) {
        let saveString = "\(record.request?.absoluteString ?? "NONE"), \(record.completionTime), \(record.response?.absoluteString ?? "NONE"), \(record.success ? "SUCCESS" : "FAILURE")\n"
        
        if let content = saveString.data(using: .utf8) {
            if let file = FileHandle(forUpdatingAtPath: self.filePath) {
                file.seekToEndOfFile()
                file.write(content)
                file.closeFile()
                block?(nil)
            } else {
                block?(RecordSaverError()) // XXX: Unique Error
            }
        } else {
            block?(RecordSaverError()) // XXX: Unique Error
        }
        
    }
}
