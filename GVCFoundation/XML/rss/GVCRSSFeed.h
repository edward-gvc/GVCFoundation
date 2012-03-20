/*
 * GVCAtomFeed.h
 * 
 * Created by David Aspinall on 12-03-13. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

#import "GVCMacros.h"
#import "GVCRSSNode.h"

GVC_DEFINE_EXTERN_STR(GVCRSS_AtomNamespace)

@class GVCRSSLink;
@class GVCRSSText;
@class GVCRSSEntry;

@interface GVCRSSFeed : GVCRSSNode

// attributes
@property (strong, nonatomic) NSString *feedNamespaceURI;
@property (strong, nonatomic) NSString *rssVersion;

// simple child nodes
@property (strong, nonatomic) NSString *feedId;
@property (strong, nonatomic) GVCRSSText *feedTitle;
@property (strong, nonatomic) GVCRSSText *feedSubTitle;
@property (strong, nonatomic) NSDate *feedUpdated;

@property (strong, nonatomic) NSMutableArray *feedLinks;
- (void)addFeedLink:(GVCRSSLink *)alink;

@property (strong, nonatomic) NSMutableArray *feedEntries;
- (void)addFeedEntry:(GVCRSSEntry *)entry;

- (BOOL)isAtomFeed;
- (void)setFeedUpdatedFromString:(NSString *)adate;
- (void)setRssPubDateFromString:(NSString *)adate;

@end
