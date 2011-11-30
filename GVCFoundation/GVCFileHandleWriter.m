/*
 * GVCFileHandleWriter.m
 * 
 * Created by David Aspinall on 11-11-25. 
 * Copyright (c) 2011 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCFileHandleWriter.h"

#import "GVCMacros.h"
#import "GVCLogger.h"
#import "NSString+GVCFoundation.h"

@implementation GVCFileHandleWriter

@synthesize log;
@synthesize logPath;

+ (GVCFileHandleWriter *)writerForFileHandle:(NSFileHandle *)file;
{
	return [[GVCFileHandleWriter alloc] initForFileHandle:file];
}

+ (GVCFileHandleWriter *)writerForFileHandle:(NSFileHandle *)file encoding:(NSStringEncoding)encoding;
{
	return [[GVCFileHandleWriter alloc] initForFileHandle:file encoding:encoding];
}

- init
{
	self = [super init];
	if ( self != nil )
	{
		writerStatus = GVC_IO_Status_INITIAL;
		stringEncoding = NSUTF8StringEncoding;
		group = dispatch_group_create();
	}
	return self;
}

- (id)initForFileHandle:(NSFileHandle *)file
{
	self = [self init];
	if ( self != nil )
	{
		[self setLog:file];
	}
	return self;
}

- (id)initForFileHandle:(NSFileHandle *)file encoding:(NSStringEncoding)encoding
{
	self = [self init];
	if ( self != nil )
	{
		[self setLog:file];
		[self setStringEncoding:encoding];
	}
	return self;
}

- (id)initForFilename:(NSString *)file encoding:(NSStringEncoding)encoding
{
	self = [self init];
	if ( self != nil )
	{
		[self setLogPath:file];
		[self setStringEncoding:encoding];
		
		NSFileHandle *handle = [NSFileHandle fileHandleForUpdatingAtPath:[self logPath]];
        GVC_ASSERT(handle != nil, @"Unable to allocate file handle for %@", [self logPath]);
		[self setLog:handle];
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

	writerStatus = GVC_IO_Status_OPEN;
}

- (void)flush
{
	GVC_ASSERT( writerStatus == GVC_IO_Status_OPEN, @"Cannot flush unless writer is open" );
	[log synchronizeFile];
}

- (void)writeString:(NSString *)str
{
	GVC_ASSERT( writerStatus == GVC_IO_Status_OPEN, @"Cannot write unless writer is open" );
    GVC_ASSERT( str != nil, @"No message" );

	dispatch_group_async( group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		if ((log != [NSFileHandle fileHandleWithStandardError]) && (log != [NSFileHandle fileHandleWithStandardOutput]))
        {
			[log seekToEndOfFile];
        }
        [log writeData:[str dataUsingEncoding:[self stringEncoding]]];
	});
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
    if ((log != [NSFileHandle fileHandleWithStandardError]) && (log != [NSFileHandle fileHandleWithStandardOutput]))
    {
        [log closeFile];
    }

    log = nil;
    
	writerStatus = GVC_IO_Status_CLOSED;
}


@end
