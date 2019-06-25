//
//  swizzler.h
//  swizzler
//
//  Created by Zachary Gorak on 6/25/19.
//  Copyright © 2019 Zachary Gorak. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for swizzler.
FOUNDATION_EXPORT double swizzlerVersionNumber;

//! Project version string for swizzler.
FOUNDATION_EXPORT const unsigned char swizzlerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <swizzler/PublicHeader.h>

@protocol SwizzlerProtocol <NSObject>
-(void) startRecording;
-(void) stopRecording;
@property (nonatomic, assign, getter=isRecording) bool recording;
@end

@interface SwizzlerObjc : NSObject <SwizzlerProtocol>
+(SwizzlerObjc *) shared;
@property (nonatomic, assign, getter=isRecording) bool recording;
@end

