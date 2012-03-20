/*
 * GVCRSSNode.h
 * 
 * Created by David Aspinall on 12-03-15. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@class GVCXMLGenerator;

@interface GVCRSSNode : NSObject

@property (strong, nonatomic) NSString *nodeName;

- (NSDate *)dateFromPosixString:(NSString *)adate;
- (NSString *)posixStringFromDate:(NSDate *)adate;

- (NSDate *)dateFromISOString:(NSString *)adate;
- (NSString *)isoStringFromDate:(NSDate *)adate;

- (void)writeRss:(GVCXMLGenerator *)outputGenerator;

@end
