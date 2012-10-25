//
//  NSDate+GVCFoundation.m
//
//  Created by David Aspinall on 11/01/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved
//

#import "NSDate+GVCFoundation.h"
#import "GVCMacros.h"
#import "GVCISO8601DateFormatter.h"
#import "GVCLogger.h"

@implementation NSDate (GVCFoundation)



+ (NSDateFormatter *)gvc_ISO8601LongDateFormatter
{
	static NSDateFormatter *iso8601LongDateFormatter = nil;
	if (iso8601LongDateFormatter == nil)
	{
		iso8601LongDateFormatter = [[NSDateFormatter alloc] init];
        [iso8601LongDateFormatter setTimeStyle:NSDateFormatterFullStyle];
        [iso8601LongDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
		[iso8601LongDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	}
	return iso8601LongDateFormatter;
}

+ (NSDateFormatter *)gvc_ISO8601ShortDateFormatter
{
	static NSDateFormatter *iso8601ShortDateFormatter = nil;
	if (iso8601ShortDateFormatter == nil)
	{
		iso8601ShortDateFormatter = [[NSDateFormatter alloc] init];
        [iso8601ShortDateFormatter setTimeStyle:NSDateFormatterFullStyle];
        [iso8601ShortDateFormatter setDateFormat:@"yyyy-MM-dd"];
		[iso8601ShortDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
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
	return [[NSDate gvc_ISO8601LongDateFormatter] stringFromDate:self];
}

+ (NSDate *)gvc_DateFromYear:(NSInteger)y month:(NSInteger)m day:(NSInteger)d
{
	GVC_DBC_FACT(d >= 1 && d <= 31);
	GVC_DBC_FACT(m >= 1 && m <= 12);
	
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
    GVC_ASSERT_NOT_EMPTY(fmt);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:fmt];
	return [formatter stringFromDate:self];
}

- (BOOL)gvc_isFutureDate
{
	return [self compare:[NSDate date]] == NSOrderedDescending;
}
@end
