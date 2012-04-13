//
//  GVCOperation.m
//
//  Created by David Aspinall on 10-01-31.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCOperation.h"
#import "GVCFunctions.h"
#import "GVCLogger.h"

GVC_DEFINE_STR(GVCOperationErrorDomain)


@interface GVCOperation ()
- (void)operationDidStartOnMainThread:(GVCOperation *)op;
- (void)operationDidFinishOnMainThread:(GVCOperation *)op;
- (void)operationDidFailOnMainThread:(GVCOperation *)op;
@end


@implementation GVCOperation

@synthesize didStartBlock;
@synthesize didFinishBlock;
@synthesize didFailWithErrorBlock;
@synthesize willFinishBlock;

@synthesize operationError;

- (GVC_Operation_Type)operationType
{
	return GVC_Operation_Type_NORMAL;
}

- (void)operationDidFailWithError:(NSError *)theError 
{
	GVCLogInfo(@"%@ failed: %@", self, theError);	
	[self setOperationError:theError];
	[self performSelectorOnMainThread:@selector(operationDidFailOnMainThread:) withObject:self waitUntilDone:[NSThread isMainThread]];
}

- (void)operationDidStart
{
	[self performSelectorOnMainThread:@selector(operationDidStartOnMainThread:) withObject:self waitUntilDone:[NSThread isMainThread]];
}

- (void)operationDidFinish
{
	[self performSelectorOnMainThread:@selector(operationDidFinishOnMainThread:) withObject:self waitUntilDone:[NSThread isMainThread]];
}

// execute the will finish block on the operation thread
- (void)operationWillFinish 
{
	if (nil != [self willFinishBlock])
	{
		self.willFinishBlock(self);
	}
}

- (void)operationDidStartOnMainThread:(GVCOperation *)op
{
	GVC_ASSERT([NSThread isMainThread], @"Should be called only on main thread");
	if (nil != [self didStartBlock])
	{
		self.didStartBlock(self);
	}
}

- (void)operationDidFinishOnMainThread:(GVCOperation *)op
{
	GVC_ASSERT([NSThread isMainThread], @"Should be called only on main thread");
	if (nil != [self didFinishBlock])
	{
		self.didFinishBlock(self);
	}
}

- (void)operationDidFailOnMainThread:(GVCOperation *)op
{
	GVC_ASSERT([NSThread isMainThread], @"Should be called only on main thread");
	if (nil != [self didFailWithErrorBlock])
	{
		self.didFailWithErrorBlock(self, [self operationError]);
	}
}

// break a possible strong cycle
- (void)setCompletionBlock:(void (^)(void))block
{
    if (block == nil) 
	{
        [super setCompletionBlock:nil];
    }
	else
	{
        __block id _blockSelf = self;
        [super setCompletionBlock:^ {
            block();
            [_blockSelf setCompletionBlock:nil];
        }];
    }
}


@end
