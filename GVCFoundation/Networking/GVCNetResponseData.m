/*
 * GVCNetResponseData.m
 * 
 * Created by David Aspinall on 12-03-20. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCNetResponseData.h"

#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "GVCNetOperation.h"

@interface GVCNetResponseData ()
// inbound data accumulator
@property (strong, nonatomic) NSMutableData *dataBuffer;
@property (assign, nonatomic) BOOL hasDataReceived;
@property (assign, nonatomic) BOOL isClosed;

@end



@implementation GVCNetResponseData

@synthesize dataBuffer;
@synthesize hasDataReceived;
@synthesize isClosed;

@synthesize defaultResponseSize;
@synthesize maximumResponseSize;
@synthesize totalBytesRead;
@synthesize responseOutputStream;
@synthesize responseBody;

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
		[self setHasDataReceived:NO];
		[self setIsClosed:YES];
        [self setTotalBytesRead:0];
        [self setDefaultResponseSize:1 * 1024 * 1024];
        [self setMaximumResponseSize:4 * 1024 * 1024];
	}
	
    return self;
}

- (BOOL)openData:(long long)expectedLength error:(NSError **)err
{
	GVC_ASSERT([self isClosed] == YES, @"Response data is already open");

	BOOL success = YES;
	if ( responseOutputStream != nil )
	{
		[[self responseOutputStream] open];
	}
	else
	{
		if (expectedLength == NSURLResponseUnknownLength) 
		{
			expectedLength = [self defaultResponseSize];
		}
		
		if (expectedLength <= (long long) [self maximumResponseSize])
		{
			[self setDataBuffer:[NSMutableData dataWithCapacity:(NSUInteger)expectedLength]];
		}
		else
		{
			*err = [NSError errorWithDomain:GVCNetOperationErrorDomain code:GVC_NetOperation_ErrorType_RESPONSE_TOO_LARGE userInfo:nil];
			success = NO;
		}
	}
	
	[self setIsClosed:(!success)];
	return success;
}

- (BOOL)closeData:(NSError **)err
{
	GVC_ASSERT([self hasDataReceived] == NO || [self isClosed] == NO, @"Response data is already closed");
	
	BOOL success = YES;
	if ( responseOutputStream != nil )
	{
		[[self responseOutputStream] close];
	}
	else
	{
		GVC_ASSERT(responseBody == nil, @"Response body already set");

		[self setResponseBody:[self dataBuffer]];
		[self setDataBuffer:nil];
	}
	[self setIsClosed:YES];
	return success;
}

- (BOOL)appendData:(NSData *)data error:(NSError **)err
{
	GVC_ASSERT([self isClosed] == NO, @"Response data is closed");
	BOOL success = YES;
	
	if ([self hasDataReceived] == NO) 
	{
        [self setHasDataReceived:YES];
    }

	if ([self dataBuffer] != nil)
	{
		if ( ([[self dataBuffer] length] + [data length]) <= [self maximumResponseSize] )
		{
			[[self dataBuffer] appendData:data];
			[self setTotalBytesRead:[self totalBytesRead] + [data length]];
		} 
		else
		{
			*err = [NSError errorWithDomain:GVCNetOperationErrorDomain code:GVC_NetOperation_ErrorType_RESPONSE_TOO_LARGE userInfo:nil];
			success = NO;
		}
	}
	else
	{
		GVC_ASSERT([self responseOutputStream] != nil, @"No response output stream");

		const uint8_t * dataPtr = [data bytes];
		NSUInteger dataLength = [data length];
		NSUInteger dataOffset = 0;
		NSInteger bytesWritten = 0;
		
		do 
		{
			if (dataOffset == dataLength) 
			{
				break;
			}
			
			bytesWritten = [[self responseOutputStream] write:&dataPtr[dataOffset] maxLength:dataLength - dataOffset];
			if (bytesWritten <= 0) 
			{
				*err = [[self responseOutputStream] streamError];
				if (*err == nil) 
				{
					*err = [NSError errorWithDomain:GVCNetOperationErrorDomain code:GVC_NetOperation_ErrorType_OUTPUT_STREAM userInfo:nil];
				}
				success = NO;
				break;
			}
			else
			{
				dataOffset += bytesWritten;
			}
		} while (YES);
	}

	if ( success == YES )
	{
		[self setTotalBytesRead:[self totalBytesRead] + [data length]];
	}
	
	return success;
}

- (void)setResponseOutputStream:(NSOutputStream *)newValue
{
	GVC_ASSERT([self hasDataReceived] == NO, @"Cannot change output stream after operation started" );

	if (newValue != responseOutputStream) 
	{
		responseOutputStream = nil;
		responseOutputStream = newValue;
	}
}

@end
