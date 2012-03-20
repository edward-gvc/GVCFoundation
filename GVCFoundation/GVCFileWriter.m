/*
 * GVCFileWriter.m
 * 
 * Created by David Aspinall on 11-11-25. 
 * Copyright (c) 2011 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCFileWriter.h"

#import "GVCMacros.h"
#import "GVCFunctions.h"

#import "GVCLogger.h"
#import "NSString+GVCFoundation.h"

@implementation GVCFileWriter

@synthesize filename;
@synthesize fileStream;

+ (GVCFileWriter *)writerForFilename:(NSString *)file
{
	return [[GVCFileWriter alloc] initForFilename:file];
}

+ (GVCFileWriter *)writerForFilename:(NSString *)file encoding:(NSStringEncoding)encoding
{
	return [[GVCFileWriter alloc] initForFilename:file encoding:encoding];
}

- init
{
	self = [super init];
	if ( self != nil )
	{
		writerStatus = GVC_IO_Status_INITIAL;
		stringEncoding = NSUTF8StringEncoding;
	}
	return self;
}

- (id)initForFilename:(NSString *)file
{
	self = [self init];
	if ( self != nil )
	{
		GVC_ASSERT(gvc_IsEmpty(file) == NO, @"Filename is empty" );
		[self setFilename:file];
	}
	return self;
}

- (id)initForFilename:(NSString *)file encoding:(NSStringEncoding)encoding
{
	self = [self init];
	if ( self != nil )
	{
		GVC_ASSERT(gvc_IsEmpty(file) == NO, @"Filename is empty" );
		[self setFilename:file];
		[self setStringEncoding:encoding];
	}
	return self;
}

- (NSStringEncoding)stringEncoding
{
	return stringEncoding;
}

- (void)setStringEncoding:(NSStringEncoding)encode
{
	GVC_ASSERT( writerStatus == GVC_IO_Status_INITIAL, @"Cannot change encoding once writer is open" );
	stringEncoding = encode;
}

- (GVCWriterStatus)status
{
	return writerStatus;
}

- (void)openWriter
{
	GVC_ASSERT( writerStatus == GVC_IO_Status_INITIAL, @"Cannot open writer more than once" );
	GVC_ASSERT( gvc_IsEmpty(filename) == NO, @"Cannot open writer for unknown file" );
	
	[self setFileStream:[NSOutputStream outputStreamToFileAtPath:[self filename] append:NO]];
	[fileStream setDelegate:self];
	[fileStream open];
	writerStatus = GVC_IO_Status_OPEN;
}

- (void)flush
{
	GVC_ASSERT( writerStatus == GVC_IO_Status_OPEN, @"Cannot flush unless writer is open" );
}

- (void)writeString:(NSString *)str
{
	GVC_ASSERT( writerStatus == GVC_IO_Status_OPEN, @"Cannot write unless writer is open" );
    GVC_ASSERT( str != nil, @"No message" );
	
	NSData *dta = [str dataUsingEncoding:[self stringEncoding]];
	[fileStream write:[dta bytes] maxLength:[dta length]];
}

- (void)writeFormat:(NSString *)fmt, ...
{
    GVC_ASSERT(fmt != nil, @"No message" );
	
	va_list args;
	va_start(args, fmt);
	NSString *message = [[NSString alloc] initWithFormat:fmt arguments:args];
	va_end(args);
	
	[self writeString:message];
}

- (void)closeWriter
{
	GVC_ASSERT( writerStatus == GVC_IO_Status_OPEN, @"Cannot close writer unless writer is open" );
	[fileStream close];
	writerStatus = GVC_IO_Status_CLOSED;
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
	if ( eventCode == NSStreamEventErrorOccurred )
		GVCLogNSError( GVCLoggerLevel_ERROR, [aStream streamError] ); 
}

@end
