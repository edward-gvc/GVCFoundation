//
//  GVCDemoDelayedOperation.m
//
//  Created by David Aspinall on 11-07-08.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCDemoDelayedOperation.h"

@implementation GVCDemoDelayedOperation

@synthesize responseData;

- initWithResponseFile:(NSString *)filename
{
	self = [super init];
	if (self != nil)
	{
		GVC_ASSERT_VALID_STRING(filename);
		[self setResponseData:[[GVCMemoryResponseData alloc] init]];
		[[self responseData] setResponseBody:[NSData dataWithContentsOfFile:filename]];
	}
	return self;
}

- (void)main
{
	if ([self isCancelled] == YES)
	{
		return;
	}
	
	[self operationDidStart];
	NSError *err = nil;
	
	[NSThread sleepForTimeInterval:1.0];
	
	if ( err != nil)
	{
		[self operationDidFailWithError:err];
	}
	else
	{
		[self operationDidFinish];
	}
}


@end
