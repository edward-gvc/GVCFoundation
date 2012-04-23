//
//  GVCStringWriter.m
//  HL7ParseTest
//
//  Created by David Aspinall on 11-01-02.
//  Copyright 2011 My Company. All rights reserved.
//

#import "GVCStringWriter.h"
#import "GVCMacros.h"

@interface GVCStringWriter ()
@property (assign, nonatomic, readwrite) GVCWriterStatus writerStatus;
@property (assign, nonatomic, readwrite) NSStringEncoding stringEncoding;
@property (strong, nonatomic) NSMutableString *stringBuffer;
@end


@implementation GVCStringWriter

@synthesize writerStatus;
@synthesize stringEncoding;
@synthesize stringBuffer;

+ (GVCStringWriter *)stringWriter
{
	return [[GVCStringWriter alloc] init];
}

- init
{
	self = [super init];
	if ( self != nil )
	{
		[self setWriterStatus:GVC_IO_Status_INITIAL];
		[self setStringEncoding:NSUTF8StringEncoding];
	}
	return self;
}

- (NSString *)string
{
	return stringBuffer;
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
