/*
 * GVCRSSLink.m
 * 
 * Created by David Aspinall on 12-03-13. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCRSSLink.h"

#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "GVCXMLGenerator.h"

GVC_DEFINE_STRVALUE(DEF_NODE_LINK, link)


@implementation GVCRSSLink

@synthesize linkHref;
@synthesize linkRel;
@synthesize linkType;
@synthesize linkHreflang;
@synthesize linkTitle;
@synthesize linkLength;
@synthesize linkIsPermaLink;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		[self setNodeName:DEF_NODE_LINK];
	}
	return self;
}

- (NSString *)description
{
	return GVC_SPRINTF(@"%@ <link href='%@'> ", GVC_CLASSNAME(self), [self linkHref]);
}

- (void)writeRss:(GVCXMLGenerator *)outputGenerator
{
	NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
	[attributes setValue:[self linkHref] forKey:@"href"];
	if ( gvc_IsEmpty(linkRel) == NO )
		[attributes setValue:[self linkRel] forKey:@"rel"];
	if ( gvc_IsEmpty(linkType) == NO )
		[attributes setValue:[self linkType] forKey:@"type"];
	if ( gvc_IsEmpty(linkHreflang) == NO )
		[attributes setValue:[self linkHreflang] forKey:@"hreflang"];
	if ( gvc_IsEmpty(linkTitle) == NO )
		[attributes setValue:[self linkTitle] forKey:@"title"];
	if ( gvc_IsEmpty(linkLength) == NO )
		[attributes setValue:[self linkLength] forKey:@"length"];
	if ( gvc_IsEmpty(linkIsPermaLink) == NO )
		[attributes setValue:[self linkIsPermaLink] forKey:@"linkIsPermaLink"];

	if ([self hasContent] == YES)
	{
		[outputGenerator openElement:[self nodeName] inNamespace:nil withAttributes:attributes];
		if ( gvc_IsEmpty([self textContent]) == NO )
		{
			[outputGenerator writeText:[self textContent]];
		}
		else
		{
			[outputGenerator writeCDATA:[[NSString alloc] initWithData:[self textCDATA] encoding:NSUTF8StringEncoding]];
		}
		[outputGenerator closeElement];
	}
	else
	{
		[outputGenerator writeElement:[self nodeName] inNamespace:nil withAttributes:attributes];
	}
}

@end
