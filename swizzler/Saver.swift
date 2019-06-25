//
//  Save.swift
//  swizzler
//
//  Created by Zachary Gorak on 6/25/19.
//  Copyright © 2019 Zachary Gorak. All rights reserved.
//

import Foundation

protocol Saver: class {
    func save(content: Data, completion block: ((Error?)->Void)?)
}

class SaveError: Error {}

/** A rudamentary CSV Saver */
class FileSaver: Saver {
    var filePath: String
    var fm = FileManager.default
    
    init?(name: String) {
        self.filePath = NSString.path(withComponents: [Bundle.main.bundlePath, name]) as String
        
        guard fm.createFile(atPath: self.filePath, contents: nil, attributes: nil) else {
            return nil
        }
        print("Swizzler output path", self.filePath)
    }
    
    func save(content: Data, completion block: ((Error?)->Void)? = nil) {
        if let file = FileHandle(forUpdatingAtPath: self.filePath) {
            file.seekToEndOfFile()
            file.write(content)
            file.closeFile()
            block?(nil)
        } else {
            block?(SaveError()) // Unique Error
        }
    }
}


