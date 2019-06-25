//
//  HTTPURLResponse.swift
//  swizzler
//
//  Created by Zachary Gorak on 6/25/19.
//  Copyright © 2019 Zachary Gorak. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    class func isSuccess(_ statusCode: Int) -> Bool {
        let validCodes = [
            // 2XX SUCCESS
            200, // OK
            201, // Created
            202, // Accepted
            203, // Non-Authoritative Information
            204, // No Content
            205, // Reset Content
            206, // Partial Content
            207, // Multi-Status (WebDAV)
            208, // Already Reported (WebDAV)
            226 // IM Used
        ]
        
        return validCodes.contains(statusCode)
    }
}
