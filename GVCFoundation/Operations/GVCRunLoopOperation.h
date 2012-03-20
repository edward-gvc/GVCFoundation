//
//  DARunLoopOperation.h
//
//  Created by David Aspinall on 10-07-10.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCOperation.h"

/**
 * $Date: 2009-10-01 23:26:28 -0400 (Thu, 01 Oct 2009) $
 * $Rev: 42 $
 * $Author: david $
*/
@interface GVCRunLoopOperation : GVCOperation 

// default is nil, implying main thread
@property (strong, nonatomic) NSThread *runLoopThread;

- (void)cancelOnRunLoopThread;
- (void)startOnRunLoopThread;

- (BOOL)isRunLoopThread;
- (NSThread *)actualRunLoopThread;

@end
