//
//  swizzle.m
//  swizzle
//
//  Created by Zachary Gorak on 6/24/19.
//  Copyright © 2019 Zachary Gorak. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <swizzler.h>
#import <swizzler/swizzler-Swift.h>

SwizzlerObjc *global = nil;

/** Start recording as soon as possible */
__attribute__((constructor))
static void initializer(int argc, char** argv, char** envp)
{
    global = [[SwizzlerObjc alloc] init];
    [global startRecording];
    // Initialization code.
}

__attribute__((destructor))
static void finalizer()
{
    [global stopRecording];
}
