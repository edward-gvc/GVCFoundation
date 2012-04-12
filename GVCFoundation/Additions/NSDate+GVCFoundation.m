//
//  NSDate+GVCFoundation.m
//
//  Created by David Aspinall on 11/01/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved
//

#import "NSDate+GVCFoundation.h"
#import "GVCMacros.h"

@implementation NSDate (GVCFoundation)



+ (NSDateFormatter *)gvc_ISO8601LongDateFormatter
{
	static NSDateFormatter *iso8601LongDateFormatter = nil;
	if (iso8601LongDateFormatter == nil)
	{
		const NSDateFormatterBehavior theOldBehavior = [NSDateFormatter defaultFormatterBehavior];
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
		iso8601LongDateFormatter = [[NSDateFormatter alloc] init];
		[iso8601LongDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
		[iso8601LongDateFormatter setDateFormat:@"yyyyy-MM-dd'T'hh:mm'Z'"];
		[NSDateFormatter setDefaultFormatterBehavior:theOldBehavior];
	}
	return iso8601LongDateFormatter;
}

+ (NSDateFormatter *)gvc_ISO8601ShortDateFormatter
{
	static NSDateFormatter *iso8601ShortDateFormatter = nil;
	if (iso8601ShortDateFormatter == nil)
	{
		const NSDateFormatterBehavior theOldBehavior = [NSDateFormatter defaultFormatterBehavior];
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
		iso8601ShortDateFormatter = [[NSDateFormatter alloc] init];
		[iso8601ShortDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
		[iso8601ShortDateFormatter setDateFormat:@"yyyyy-MM-dd"];
		[NSDateFormatter setDefaultFormatterBehavior:theOldBehavior];
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


- (BOOL)gvc_isFutureDate
{
	return [self compare:[NSDate date]] == NSOrderedDescending;
}
@end
