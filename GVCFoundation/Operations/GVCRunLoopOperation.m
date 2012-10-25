//
//  DARunLoopOperation.m
//
//  Created by David Aspinall on 10-07-10.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCRunLoopOperation.h"
#import "GVCLogger.h"


@interface GVCRunLoopOperation()

@property (strong, readonly ) NSThread *actualRunLoopThread;
@property (assign, readonly ) BOOL	isRunLoopThread;

@end


/**
 * $Date: 2009-01-20 16:28:51 -0500 (Tue, 20 Jan 2009) $
 * $Rev: 121 $
 * $Author: david $
*/
@implementation GVCRunLoopOperation

@synthesize runLoopThread;


- (id)init
{
	self = [super init];
	if (self != nil)
	{
	}
	return self;
}

// a run loop operation implies concurrent
- (BOOL)isConcurrent
{
    return YES;
}


/** Implementation */

- (void)setRunLoopThread:(NSThread *)newValue
{
	GVC_ASSERT([self isExecuting] == NO, @"Cannot change runloop on running operation");
	
	if (newValue != [self runLoopThread])
	{
		[self willChangeValueForKey:@"runLoopThread"];
		runLoopThread = newValue;
		[self didChangeValueForKey:@"runLoopThread"];
    }
}

// Returns the effective run loop thread, that is, the one set by the user 
// or, if that's not set, the main thread.
- (NSThread *)actualRunLoopThread
{
    NSThread *result = [self runLoopThread];
    if (result == nil) 
	{
        result = [NSThread mainThread];
    }
    return result;
}

- (BOOL)isRunLoopThread
{
    return [[NSThread currentThread] isEqual:[self actualRunLoopThread]];
}

- (void)startOnRunLoopThread
{
	GVC_SUBCLASS_RESPONSIBLE;
}

- (void)cancelOnRunLoopThread
// Cancels the operation.  The actual -cancel method is very simple, 
// deferring all of the work to be done on the run loop thread by this 
// method.
{
    GVC_ASSERT([self isRunLoopThread], @"Not on run loop thread" );
	
    // Because we're always running on the run loop thread, we don't need 
    // synchronisation for the test-and-set of _cancelled.
    
    if ([self isCancelled] == NO)
	{
		[self cancel];
    }
}

- (void)start
{
	if ([self isCancelled] == YES)
	{
		return;
	}

	GVC_ASSERT([self isExecuting] == NO, @"Operation already in progress");
    
    // Have to change the state here, otherwise isExecuting won't necessarily return 
    // true by the time return from -start.  Also, we don't test for cancellation 
    // here because that would result is sending isFinished notifications on a 
    // thread that isn't our runloop thread.
    
	[self operationDidStart];
    [self performSelector:@selector(startOnRunLoopThread) onThread:[self actualRunLoopThread] withObject:nil waitUntilDone:NO];
}

@end
