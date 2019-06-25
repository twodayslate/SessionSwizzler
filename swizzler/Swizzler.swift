//
//  Swizzler.swift
//  swizzle
//
//  Created by Zachary Gorak on 6/24/19.
//  Copyright © 2019 Zachary Gorak. All rights reserved.
//

import Foundation
import swizzler

@objc public class Swizzler: NSObject{
    
    @objc public static let shared = Swizzler()
    @objc public var isRecording: Bool = false
    /** the default saver is a FileSaver with "tmp" as the name */
    var saver: Saver = FileSaver(name: "tmp")!
    
    /**
     * This is an internal method and should not be called directly
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
     * This is an internal method and should not be called directly
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
     * Handle Responses from recordings
     *
     * - parameter task: The task
     * - parameter request: The original request
     * - parameter response: The response, if any
     * - parameter error: An error, if any
     * - parameter taskCreated: the time the task was created, note this is not
     *                      the same thing as when the task was started/resumed
     */
    @objc public func handleResponse(task: URLSessionTask, request: URLRequest?, response: URLResponse?, error: Error?, taskCreated: Date) {
        
        guard self.isRecording else {
            return
        }
        
        // We are only interested in HTTP requests
        guard let method = request?.httpMethod else {
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
        
        // Hack to remove duplicates
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
        
        let record = Recording(request: requestURL, response: responseURL, completionTime: timeDiffInMiliseconds, success: wasSuccess)
        record.save(self.saver)
    }
}
