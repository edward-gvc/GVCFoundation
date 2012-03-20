/*
 * GVCAtomFeed.m
 * 
 * Created by David Aspinall on 12-03-13. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCRSSFeed.h"

#import "GVCRSSLink.h"
#import "GVCRSSText.h"
#import "GVCRSSEntry.h"

#import "GVCFunctions.h"
#import "GVCXMLGenerator.h"

#import "NSString+GVCFoundation.h"

NSString * const GVCRSS_AtomNamespace = @"http://www.w3.org/2005/Atom";

GVC_DEFINE_STRVALUE(DEF_NODE_FEED, feed)

@interface GVCRSSFeed ()
@end

@implementation GVCRSSFeed

@synthesize feedNamespaceURI;
@synthesize rssVersion;
@synthesize feedId;
@synthesize feedTitle;
@synthesize feedSubTitle;
@synthesize feedUpdated;

@synthesize feedLinks;
@synthesize feedEntries;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		[self setNodeName:DEF_NODE_FEED];
	}
	return self;
}

- (BOOL)isAtomFeed
{
	return (gvc_IsEmpty(feedNamespaceURI) == NO && [feedNamespaceURI isEqualToString:GVCRSS_AtomNamespace]);
}

- (void)setFeedUpdatedFromString:(NSString *)adate
{
	[self setFeedUpdated:[self dateFromISOString:adate]];
}

- (void)setRssPubDateFromString:(NSString *)adate
{
	[self setFeedUpdated:[self dateFromPosixString:adate]];
}

- (void)addFeedEntry:(GVCRSSEntry *)entry
{
	if ( [self feedEntries] == nil )
	{
		[self setFeedEntries:[[NSMutableArray alloc] init]];
	}
	[[self feedEntries] addObject:entry];
}

- (void)addFeedLink:(GVCRSSLink *)alink
{
	if ( [self feedLinks] == nil )
	{
		[self setFeedLinks:[[NSMutableArray alloc] init]];
	}
	[[self feedLinks] addObject:alink];
}

- (NSString *)description
{
	return GVC_SPRINTF(@"%@ <%@> id=%@, title=%@, subtitle=%@, updated=%@ %@", GVC_CLASSNAME(self), [self nodeName], [self feedId], [self feedTitle], [self feedSubTitle], [self feedUpdated], [self feedLinks]);
}

- (void)writeRss:(GVCXMLGenerator *)outputGenerator
{
	[outputGenerator openDocumentWithDeclaration:YES andEncoding:YES];
	[outputGenerator openElement:[self nodeName] inNamespacePrefix:nil forURI:[self feedNamespaceURI]];
	
	if ( gvc_IsEmpty([self feedId]) == NO)
		[outputGenerator writeElement:@"id" withText:[self feedId]];
	if ( gvc_IsEmpty([self feedUpdated]) == NO)
		[outputGenerator writeElement:@"updated" withText:[[self feedUpdated] description]];
	
	[[self feedTitle] writeRss:outputGenerator];
	[[self feedSubTitle] writeRss:outputGenerator];

	for (GVCRSSLink *link in [self feedLinks])
	{
		[link writeRss:outputGenerator];
	}
	for (GVCRSSEntry *entry in [self feedEntries])
	{
		[entry writeRss:outputGenerator];
	}


	[outputGenerator closeElement];
	[outputGenerator closeDocument];
}


@end
