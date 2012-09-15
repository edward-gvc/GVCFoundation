//
//  DARunLoopOperation.h
//
//  Created by David Aspinall on 10-07-10.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCOperation.h"

/**
 * Run Loop operations are used for processes that will create their own threads and simply need to be monitored periodically.  NSURLConnection is an example of this kind of processing.
 */
@interface GVCRunLoopOperation : GVCOperation

/** The run loop thread executing this operation.  If not specified will execute on the main thread */
@property (strong, nonatomic) NSThread *runLoopThread;

/** should not be called directly.  Use [operation cancel] instead */
- (void)cancelOnRunLoopThread;

/** should not be called directly.  the NSOperationQueue will start this operation as required */
- (void)startOnRunLoopThread;

/** confirms the current thread is the same thread this operation is supposed to be executing on */
- (BOOL)isRunLoopThread;

/** the actual thread of execution, may be different from the runLoopThread property */
- (NSThread *)actualRunLoopThread;

@end
