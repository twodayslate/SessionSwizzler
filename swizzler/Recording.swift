//
//  Recording.swift
//  swizzler
//
//  Created by Zachary Gorak on 6/25/19.
//  Copyright © 2019 Zachary Gorak. All rights reserved.
//

import Foundation

struct Recording: Codable {
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
     * Calls the Saver's save function, allows for different types of savers
     */
    func save(_ with: Saver, completion block: ((Error?)->Void)? = nil) {
        let saveString = "\(request?.absoluteString ?? "NONE"), \(completionTime), \(response?.absoluteString ?? "NONE"), \(success ? "SUCCESS" : "FAILURE")\n"
        
        if let data = saveString.data(using: .utf8) {
            with.save(content: data, completion: block)
        } else {
            block?(SaveError()) // XXX: Unique Error
        }
    }
}
