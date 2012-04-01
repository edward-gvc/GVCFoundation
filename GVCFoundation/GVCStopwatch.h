/*
 * GVCStopwatch.h
 * 
 * Created by David Aspinall on 12-03-29. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@interface GVCStopwatch : NSObject

- (void)start;
- (void)stop;
- (void)reset;

- (BOOL)isRunning;

- (NSTimeInterval)elapsed;

@end
