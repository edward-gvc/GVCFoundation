/*
 * GVCNetResponseData.h
 * 
 * Created by David Aspinall on 12-03-20. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@interface GVCNetResponseData : NSObject

	// is set to YES on the first data packet
@property (readonly, nonatomic) BOOL hasDataReceived;

	// is set to YES when the data is final
@property (readonly, nonatomic) BOOL isClosed;

    // (1MB) default response size assumed if no length provided by remote, and no output stream
@property (assign, nonatomic) NSUInteger defaultResponseSize;

    // (4MB) maximum in-memory response size, causes error if data is greater and no output stream
@property (assign, nonatomic) NSUInteger maximumResponseSize;    

@property (assign, nonatomic) NSUInteger totalBytesRead;

	// defaults to nil, which puts response into responseBody
@property (strong, nonatomic) NSOutputStream *responseOutputStream;

	// data container for in memory response
@property (strong, nonatomic)  NSData *responseBody;   

- (BOOL)appendData:(NSData *)data error:(NSError **)err;
- (BOOL)openData:(long long)expectedLength error:(NSError **)err;
- (BOOL)closeData:(NSError **)err;
@end
