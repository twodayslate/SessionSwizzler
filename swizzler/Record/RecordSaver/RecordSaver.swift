//
//  Save.swift
//  swizzler
//
//  Created by Zachary Gorak on 6/25/19.
//  Copyright © 2019 Zachary Gorak. All rights reserved.
//

import Foundation

protocol RecordSaver: class {
    func save(record: Record, completion block: ((Error?)->Void)?)
}

class RecordSaverError: Error {}
