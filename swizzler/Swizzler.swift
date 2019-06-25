//
//  Swizzler.swift
//  swizzle
//
//  Created by Zachary Gorak on 6/24/19.
//  Copyright © 2019 Zachary Gorak. All rights reserved.
//

import Foundation

@objc public class Swizzler: NSObject{
    
    /** Returns the shared Swizzler object.*/
    @objc public static let shared = Swizzler()
    
    /** Whether or not URLSession tasks are being recorded */
    @objc public var isRecording: Bool = false
    
    /** the default saver is a FileSaver with "tmp" as the name */
    var saver: RecordSaver = FileRecordSaver(name: "tmp")!
    
    /**
     Calls SwizzlerObjc's startRecording method and sets the appropriate flags
     - warning: This is an internal method and should not be called directly, try SwizzlerObjc
     */
    @objc public func startRecording() {
        //SwizzlerObjc.shared.startRecording()
        guard !self.isRecording else {
            return
        }
        self.isRecording = true
        SwizzlerObjc.shared()?.startRecording()
    }
    
    /**
    Calls SwizzlerObjc's stopRecording method and sets the appropriate flags
     - warning: This is an internal method and should not be called directly, try SwizzlerObjc
     */
    @objc public func stopRecording() {
        guard self.isRecording else {
            return
        }
        
        self.isRecording = false
        SwizzlerObjc.shared()?.stopRecording()
    }
    
    // hack to remove duplicates from RSSwizzle
    var responses = [URLResponse?]()
    
    /**
    Handle URLSession task responses, creates a Recording and saves it using `Saver`
    
    - parameters:
        - task: The task
        - request: The original request
        - response: The response, if any
        - error: An error, if any
        - taskCreated: the time the task was created, note this is not
                       the same thing as when the task was started/resumed
     */
    @objc public func handleResponse(task: URLSessionTask, request: URLRequest?, response: URLResponse?, error: Error?, taskCreated: Date) {
        
        guard self.isRecording else {
            return
        }
        
        guard let requestURL = request?.url else {
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }
        
        guard let responseURL = httpResponse.url else {
            return
        }
        
        // XXX: Hack to remove duplicates
        if response != nil && responses.contains(response) {
            return
        }
        if response != nil {
            responses.append(response)
        }
        
        let currentTime = Date(timeIntervalSinceNow: 0)
        let timeDiff = currentTime.timeIntervalSince(taskCreated)
        
        // there shouldn't be a time when a request took negative seconds
        guard timeDiff > 0 else {
            return
        }
        
        let timeDiffInMiliseconds = Int(ceil(timeDiff * 1000))
        
        let wasSuccess = (error == nil) && HTTPURLResponse.isSuccess(httpResponse.statusCode)
        
        let record = Record(request: requestURL, response: responseURL, completionTime: timeDiffInMiliseconds, success: wasSuccess)
        record.save(with: self.saver)
    }
}
