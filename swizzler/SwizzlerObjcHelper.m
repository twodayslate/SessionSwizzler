//
//  SwizzlerObjcHelper.m
//  swizzle
//
//  Created by Zachary Gorak on 6/24/19.
//  Copyright © 2019 Zachary Gorak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <swizzler.h>
#import <swizzler/swizzler-Swift.h>
#import <RSSwizzle/RSSwizzle.h>

@implementation SwizzlerObjc

+(SwizzlerObjc *)shared {
    static SwizzlerObjc *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

/**
 * Swizzle the appropriate URLSession tasks and send it to the Swizzler handler
 */
-(void) startRecording {
    if (self.isRecording) {
        return;
    }
    
    self.recording = YES;
    // We don't have to swizzle dataTaskWithURL: or dataTaskWithURL:completionHandler: as they call this function
    // We can't swizzle this in Swift since the selector is ambigious :(
    // MARK: - dataTaskWithRequest:completionHandler:
    RSSwizzleInstanceMethod(NSURLSession, @selector(dataTaskWithRequest:completionHandler:), RSSWReturnType(NSURLSessionDataTask *), RSSWArguments(NSURLRequest *request, void(^completionHandler)(NSData *data, NSURLResponse *response, NSError *error)), RSSWReplacement({
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        void(^newCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error) = ^void(NSData *data, NSURLResponse *response, NSError *error){
            if ([[SwizzlerObjc shared] isRecording]) {
                [[Swizzler shared] handleResponseWithTask:self request:request response:response error: error taskCreated: date];
            }
            if(completionHandler != nil) {
                completionHandler(data, response, error);
            }
        };
        
        return RSSWCallOriginal(request, newCompletionHandler); // XXX: this duplicates calls
    }), RSSwizzleModeAlways, NULL)
    
    // MARK: - downloadTaskWithURL:completionHandler:
    RSSwizzleInstanceMethod(NSURLSession, @selector(downloadTaskWithURL:completionHandler:), RSSWReturnType(NSURLSessionDownloadTask *), RSSWArguments(NSURL *request, void(^completionHandler)(NSURL *location, NSURLResponse *response, NSError *error)), RSSWReplacement({
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        
        void(^newCompletionHandler)(NSURL *location, NSURLResponse *response, NSError *error) = ^void(NSURL *location, NSURLResponse *response, NSError *error){
            if([[SwizzlerObjc shared] isRecording]) {
                [[Swizzler shared] handleResponseWithTask:self request:nil response:response error: error taskCreated: date];
            }
            if(completionHandler != nil) {
                completionHandler(location, response, error);
            }
        };
        return RSSWCallOriginal(request, newCompletionHandler); // XXX: duplicate calls?
    }), RSSwizzleModeAlways, NULL)
    
    // MARK: - downloadTaskWithRequest:completionHandler:
    RSSwizzleInstanceMethod(NSURLSession, @selector(downloadTaskWithRequest:completionHandler:), RSSWReturnType(NSURLSessionDownloadTask *), RSSWArguments(NSURLRequest *request, void(^completionHandler)(NSURL *location, NSURLResponse *response, NSError *error)), RSSWReplacement({
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        
        void(^newCompletionHandler)(NSURL *location, NSURLResponse *response, NSError *error) = ^void(NSURL *location, NSURLResponse *response, NSError *error){
            if([[SwizzlerObjc shared] isRecording]) {
                [[Swizzler shared] handleResponseWithTask:self request:request response:response error: error taskCreated: date];
            }
            if(completionHandler != nil) {
                completionHandler(location, response, error);
            }
        };
        return RSSWCallOriginal(request, newCompletionHandler); // XXX: this duplicates calls
    }), RSSwizzleModeAlways, NULL)
    
    // MARK: - downloadTaskWithRequest:
    RSSwizzleInstanceMethod(NSURLSession, @selector(downloadTaskWithRequest:), RSSWReturnType(NSURLSessionDownloadTask *), RSSWArguments(NSURLRequest *request), RSSWReplacement({
        return [self downloadTaskWithRequest:request completionHandler:nil]; // call our useful hook
    }), RSSwizzleModeAlways, NULL)
    
    // MARK: - downloadTaskWithResumeData:completionHandler:
    RSSwizzleInstanceMethod(NSURLSession, @selector(downloadTaskWithResumeData:completionHandler:), RSSWReturnType(NSURLSessionDownloadTask *), RSSWArguments(NSData *data, void(^completionHandler)(NSData *data, NSURLResponse *response, NSError *error)), RSSWReplacement({
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        void(^newCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error) = ^void(NSData *data, NSURLResponse *response, NSError *error){
            if([[SwizzlerObjc shared] isRecording]) {
                [[Swizzler shared] handleResponseWithTask:self request:nil response:response error: error taskCreated:date];
            }
            if(completionHandler != nil) {
                completionHandler(data, response, error);
            }
        };
        
        return RSSWCallOriginal(data, newCompletionHandler); // XXX: duplicate calls?
    }), RSSwizzleModeAlways, NULL)
    
    // MARK: - uploadTaskWithRequest:fromFile:completionHandler:
    RSSwizzleInstanceMethod(NSURLSession, @selector(uploadTaskWithRequest:fromFile:completionHandler:), RSSWReturnType(NSURLSessionUploadTask *), RSSWArguments(NSURLRequest *request, NSURL* file, void(^completionHandler)(NSData *data, NSURLResponse *response, NSError *error)), RSSWReplacement({
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        
        void(^newCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error) = ^void(NSData *data, NSURLResponse *response, NSError *error){
            if([[SwizzlerObjc shared] isRecording]) {
                [[Swizzler shared] handleResponseWithTask:self request:nil response:response error: error taskCreated: date];
            }
            if(completionHandler != nil) {
                completionHandler(data, response, error);
            }
        };
        return RSSWCallOriginal(request, file, newCompletionHandler); // XXX: duplicate calls?
    }), RSSwizzleModeAlways, NULL)
    
    // MARK: - uploadTaskWithRequest:fromData:completionHandler:
    RSSwizzleInstanceMethod(NSURLSession, @selector(uploadTaskWithRequest:fromData:completionHandler:), RSSWReturnType(NSURLSessionUploadTask *), RSSWArguments(NSURLRequest *request, NSData* file, void(^completionHandler)(NSData *data, NSURLResponse *response, NSError *error)), RSSWReplacement({
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        
        void(^newCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error) = ^void(NSData *data, NSURLResponse *response, NSError *error){
            if([[SwizzlerObjc shared] isRecording]) {
                [[Swizzler shared] handleResponseWithTask:self request:nil response:response error: error taskCreated: date];
            }
            if(completionHandler != nil) {
                completionHandler(data, response, error);
            }
        };
        return RSSWCallOriginal(request, file, newCompletionHandler); // XXX: this duplicates calls
    }), RSSwizzleModeAlways, NULL)
    
    // MARK: - uploadTaskWithRequest:fromData:
    RSSwizzleInstanceMethod(NSURLSession, @selector(uploadTaskWithRequest:fromData:), RSSWReturnType(NSURLSessionUploadTask *), RSSWArguments(NSURLRequest *request, NSData* file), RSSWReplacement({
        return [self uploadTaskWithRequest:request fromData:file completionHandler:nil];
    }), RSSwizzleModeAlways, NULL)
    
    // TODO: all the other types of tasks and make sure we got all the edge cases
    
    [[Swizzler shared] startRecording];
}

/**
 * Stop sending task data to the Swizzle handler
 */
-(void) stopRecording {
    [self setRecording:NO];
    
    [[Swizzler shared] stopRecording];
    
    // XXX: How to unswizzle with RSSwizzle? For now we just won't record but still swizzle
}
@end
