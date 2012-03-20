/*
 * GVCRSSEntry.m
 * 
 * Created by David Aspinall on 12-03-15. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCRSSEntry.h"

#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "GVCXMLGenerator.h"

#import "GVCRSSLink.h"
#import "GVCRSSText.h"

GVC_DEFINE_STRVALUE(DEF_NODE_ENTRY, entry)

@implementation GVCRSSEntry

@synthesize entryId;
@synthesize entryTitle;
@synthesize entryUpdated;
@synthesize entryContent;
@synthesize entrySummary;
@synthesize entryLinks;

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
		[self setNodeName:DEF_NODE_ENTRY];
	}
	
    return self;
}

- (void)addEntryLink:(GVCRSSLink *)alink
{
	if ( [self entryLinks] == nil )
	{
		[self setEntryLinks:[[NSMutableArray alloc] init]];
	}
	[[self entryLinks] addObject:alink];
}

- (void)setEntryUpdatedFromString:(NSString *)adate
{
	[self setEntryUpdated:[self dateFromISOString:adate]];
}

- (void)setEntryPubDateFromString:(NSString *)adate
{
	[self setEntryUpdated:[self dateFromPosixString:adate]];
}

- (void)writeRss:(GVCXMLGenerator *)outputGenerator
{
	[outputGenerator openElement:@"entry"];
	if (gvc_IsEmpty([self entryId]) == NO)
		[outputGenerator writeElement:@"id" withText:[self entryId]];
	if (gvc_IsEmpty([self entryUpdated]) == NO)
		[outputGenerator writeElement:@"updated" withText:[[self entryUpdated] description]];
	
	[[self entryTitle] writeRss:outputGenerator];
	[[self entryContent] writeRss:outputGenerator];
	[[self entrySummary] writeRss:outputGenerator];
	for (GVCRSSLink *link in [self entryLinks])
	{
		[link writeRss:outputGenerator];
	}
	[outputGenerator closeElement];
}


@end
