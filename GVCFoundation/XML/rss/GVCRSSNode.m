/*
 * GVCRSSNode.m
 * 
 * Created by David Aspinall on 12-03-15. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCRSSNode.h"
#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "GVCISO8601DateFormatter.h"
#import "GVCXMLGenerator.h"
#import "GVCStringWriter.h"

@implementation GVCRSSNode

@synthesize nodeName;

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
	}
	
    return self;
}

- (NSDate *)dateFromPosixString:(NSString *)adate;
{
	NSDate *value = nil;
	if (gvc_IsEmpty(adate) == NO )
	{
		NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
		NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
		[formatter setLocale:locale];
		[formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
		value = [formatter dateFromString:adate];
	}
	return value;
}

- (NSString *)posixStringFromDate:(NSDate *)adate
{
	NSString *value = nil;
	if ( adate != nil )
	{
		NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
		NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
		[formatter setLocale:locale];
		[formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
		value = [formatter stringFromDate:adate];
	}
	return value;
}

- (NSDate *)dateFromISOString:(NSString *)adate;
{
	NSDate *value = nil;
	if (gvc_IsEmpty(adate) == NO )
	{
		GVCISO8601DateFormatter *fmtter = [[GVCISO8601DateFormatter alloc] init];
		[fmtter setFormat:GVCISO8601DateFormatter_Calendar];
		value = [fmtter dateFromString:adate];
	}
	return value;
}

- (NSString *)isoStringFromDate:(NSDate *)adate
{
	NSString *value = nil;
	if ( adate != nil )
	{
		GVCISO8601DateFormatter *fmtter = [[GVCISO8601DateFormatter alloc] init];
		[fmtter setFormat:GVCISO8601DateFormatter_Calendar];
		value = [fmtter stringFromDate:adate timeZone:[NSTimeZone localTimeZone]];
	}
	return value;
}

- (void)writeRss:(GVCXMLGenerator *)outputGenerator
{
	[outputGenerator writeElement:GVC_CLASSNAME(self) withText:[self description]];
}

- (NSString *)description
{
    GVCStringWriter *stringWriter = [[GVCStringWriter alloc] init];
    GVCXMLGenerator *generator = [[GVCXMLGenerator alloc] initWithWriter:stringWriter andFormat:GVC_XML_GeneratorFormat_PRETTY];
    [self writeRss:generator];
    return [stringWriter string];
}


@end
