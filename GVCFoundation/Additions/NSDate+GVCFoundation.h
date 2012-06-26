//
//  NSDate+GVCFoundation.h
//
//  Created by David Aspinall on 11/01/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved
//

#import <Foundation/Foundation.h>

@class GVCISO8601DateFormatter;

@interface NSDate (GVCFoundation)

+ (GVCISO8601DateFormatter *)gvc_ISO8601LongDateFormatter;
+ (GVCISO8601DateFormatter *)gvc_ISO8601ShortDateFormatter;

+ (NSDate *)gvc_DateFromISO8601:(NSString *)value;
+ (NSDate *)gvc_DateFromISO8601ShortValue:(NSString *)value;

+ (NSDate *)gvc_DateFromYear:(NSInteger)y month:(NSInteger)m day:(NSInteger)d;

- (NSString *)gvc_iso8601ShortStringValue;
- (NSString *)gvc_iso8601StringValue;

- (BOOL)gvc_isFutureDate;

- (NSString *)gvc_FormattedStyle:(NSDateFormatterStyle)style;
- (NSString *)gvc_FormattedStringValue:(NSString *)fmt;

@end
