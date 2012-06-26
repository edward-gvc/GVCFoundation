//
//  NSDate+GVCFoundation.m
//
//  Created by David Aspinall on 11/01/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved
//

#import "NSDate+GVCFoundation.h"
#import "GVCMacros.h"
#import "GVCISO8601DateFormatter.h"

@implementation NSDate (GVCFoundation)



+ (GVCISO8601DateFormatter *)gvc_ISO8601LongDateFormatter
{
	static GVCISO8601DateFormatter *iso8601LongDateFormatter = nil;
	if (iso8601LongDateFormatter == nil)
	{
		iso8601LongDateFormatter = [[GVCISO8601DateFormatter alloc] init];
		[(GVCISO8601DateFormatter *)iso8601LongDateFormatter setFormat:GVCISO8601DateFormatter_Calendar];
		[(GVCISO8601DateFormatter *)iso8601LongDateFormatter setIncludeTime:YES];
	}
	return iso8601LongDateFormatter;
}

+ (GVCISO8601DateFormatter *)gvc_ISO8601ShortDateFormatter
{
	static GVCISO8601DateFormatter *iso8601ShortDateFormatter = nil;
	if (iso8601ShortDateFormatter == nil)
	{
		iso8601ShortDateFormatter = [[GVCISO8601DateFormatter alloc] init];
		[(GVCISO8601DateFormatter *)iso8601ShortDateFormatter setFormat:GVCISO8601DateFormatter_Calendar];
		[(GVCISO8601DateFormatter *)iso8601ShortDateFormatter setIncludeTime:NO];
	}
	return iso8601ShortDateFormatter;
}

+ (NSDate *)gvc_DateFromISO8601:(NSString *)value
{
	return [[NSDate gvc_ISO8601LongDateFormatter] dateFromString:value];
}

+ (NSDate *)gvc_DateFromISO8601ShortValue:(NSString *)value
{
	return [[NSDate gvc_ISO8601ShortDateFormatter] dateFromString:value];
}

- (NSString *)gvc_iso8601ShortStringValue
{
	return [[NSDate gvc_ISO8601ShortDateFormatter] stringFromDate:self];
}

- (NSString *)gvc_iso8601StringValue
{
	return [[NSDate gvc_ISO8601LongDateFormatter] stringFromDate:self timeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
}

+ (NSDate *)gvc_DateFromYear:(NSInteger)y month:(NSInteger)m day:(NSInteger)d
{
	GVC_ASSERT(d >= 1 && d <= 31, @"Invalid day %d", d);
	GVC_ASSERT(m >= 1 && m <= 12, @"Invalid month %d", m);
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:d];
	[comps setMonth:m];
	[comps setYear:y];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *date = [gregorian dateFromComponents:comps];
	
	return date;
}

- (NSString *)gvc_FormattedStyle:(NSDateFormatterStyle)style
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:style];
    return [formatter stringFromDate:self];
}

- (NSString *)gvc_FormattedStringValue:(NSString *)fmt
{
    GVC_ASSERT_VALID_STRING(fmt);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:fmt];
	return [formatter stringFromDate:self];
}

- (BOOL)gvc_isFutureDate
{
	return [self compare:[NSDate date]] == NSOrderedDescending;
}
@end
