/*
 * GVCRSSEntry.h
 * 
 * Created by David Aspinall on 12-03-15. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCRSSNode.h"

@class GVCRSSLink;
@class GVCRSSText;

@interface GVCRSSEntry : GVCRSSNode

@property (strong, nonatomic) NSString *entryId;
@property (strong, nonatomic) GVCRSSText *entryTitle;
@property (strong, nonatomic) NSDate *entryUpdated;
@property (strong, nonatomic) GVCRSSText *entryContent;
@property (strong, nonatomic) GVCRSSText *entrySummary;
@property (strong, nonatomic) NSMutableArray *entryLinks;


- (void)addEntryLink:(GVCRSSLink *)alink;
- (void)setEntryUpdatedFromString:(NSString *)adate;
- (void)setEntryPubDateFromString:(NSString *)adate;

@end
