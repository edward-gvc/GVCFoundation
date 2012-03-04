//
//  GVCStringWriter.m
//  HL7ParseTest
//
//  Created by David Aspinall on 11-01-02.
//  Copyright 2011 My Company. All rights reserved.
//

#import "GVCStringWriter.h"
#import "GVCMacros.h"

@implementation GVCStringWriter

+ (GVCStringWriter *)stringWriter
{
	return [[GVCStringWriter alloc] init];
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

- (NSString *)string
{
	return stringBuffer;
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

- (GVC_IO_Status)status
{
	return writerStatus;
}

- (void)openWriter
{
	GVC_ASSERT( writerStatus == GVC_IO_Status_INITIAL, @"Cannot open writer more than once" );
	GVC_ASSERT( stringBuffer == nil, @"String buffer improperly initialized" );
	
	stringBuffer = [[NSMutableString alloc] init];
	writerStatus = GVC_IO_Status_OPEN;
}

- (void)flush
{}

- (void)writeString:(NSString *)str
{
	GVC_ASSERT( writerStatus == GVC_IO_Status_OPEN, @"Cannot write unless writer is open" );
	GVC_ASSERT( stringBuffer != nil, @"String buffer not initialized" );
    GVC_ASSERT( str != nil, @"No message" );
	
	[stringBuffer appendString:str];
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
	writerStatus = GVC_IO_Status_CLOSED;
}

@end
