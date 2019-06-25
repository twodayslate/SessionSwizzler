//
//  Recording.swift
//  swizzler
//
//  Created by Zachary Gorak on 6/25/19.
//  Copyright © 2019 Zachary Gorak. All rights reserved.
//

import Foundation

struct Record: Codable {
    var request: URL?
    var response: URL?
    var completionTime: Int
    var success: Bool
    
    var asJSON: String? {
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(self) {
            return String(data: data, encoding: .utf8)
        }

        return nil
    }
    
    /**
     Calls the Saver's save function, allows for different types of savers
     
     - parameters:
        - saver: The saver.
        - completion: The completion block to be run after a successful or failed save
     */
    func save(with saver: RecordSaver, completion block: ((Error?)->Void)? = nil) {
        saver.save(record: self, completion: block)
    }
}
