//
//  Swift.swift
//  swizzler
//
//  Created by Zachary Gorak on 6/25/19.
//  Copyright © 2019 Zachary Gorak. All rights reserved.
//

import Foundation

// Disable printing in release mode

#if RELEASE
public func debugPrint(items: Any..., separator: String = " ", terminator: String = "\n") {
    
}
public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    
}
#endif
