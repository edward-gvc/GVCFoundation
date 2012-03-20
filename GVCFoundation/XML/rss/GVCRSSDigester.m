/*
 * GVCRSSDigester.m
 * 
 * Created by David Aspinall on 12-03-14. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCRSSDigester.h"

#import "GVCMacros.h"
#import "GVCFunctions.h"

#import "GVCXMLGenerator.h"
#import "GVCXMLDigesterRule.h"
#import "GVCXMLDigesterRuleManager.h"
#import "GVCXMLDigesterRuleset.h"
#import "GVCXMLDigesterAttributeMapRule.h"
#import "GVCXMLDigesterPairAttributeTextRule.h"

@implementation GVCRSSDigester

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
		// Atom
		[self addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCRSSFeed"] forPattern:@"^feed"];
		GVCXMLDigesterAttributeMapRule *feedNamespace = [[GVCXMLDigesterAttributeMapRule alloc] initWithKeysAndValues:@"xmlns", @"feedNamespaceURI", nil];
		[self addRule:feedNamespace forPattern:@"^feed"];

		// RSS
		[self addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCRSSFeed"] forPattern:@"^rss"];
		GVCXMLDigesterAttributeMapRule *rssAttributes = [[GVCXMLDigesterAttributeMapRule alloc] initWithKeysAndValues:@"version", @"rssVersion", nil];
		[self addRule:rssAttributes forPattern:@"^rss"];

		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyText:@"feedId"] forPattern:@"^feed/id"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyText:@"feedUpdatedFromString"] forPattern:@"^feed/updated"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyText:@"rssPubDateFromString"] forPattern:@"^rss/channel/pubDate"];

		// feed/entry
		[self addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCRSSEntry"] forPattern:@"entry"];
		[self addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCRSSEntry"] forPattern:@"item"];
		[self addRule:[GVCXMLDigesterRule ruleForParentChild:@"feedEntry"] forPattern:@"^feed/entry"];
		[self addRule:[GVCXMLDigesterRule ruleForParentChild:@"feedEntry"] forPattern:@"^rss/channel/item"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyText:@"entryId"] forPattern:@"^feed/entry/id"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyText:@"entryUpdatedFromString"] forPattern:@"^feed/entry/updated"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyText:@"entryPubDateFromString"] forPattern:@"^rss/channel/item/pubDate"];

		// create <title>, <subtitle> <content> rule
		[self addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCRSSText"] forPattern:@"title"];
		[self addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCRSSText"] forPattern:@"subtitle"];
		[self addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCRSSText"] forPattern:@"content"];
		[self addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCRSSText"] forPattern:@"summary"];
		[self addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCRSSText"] forPattern:@"description"];
		
		// node name rule
		GVCXMLDigesterElementNamePropertyRule *nodeName = [[GVCXMLDigesterElementNamePropertyRule alloc] initWithPropertyName:@"nodeName"];
		[self addRule:nodeName forPattern:@"feed"];
		[self addRule:nodeName forPattern:@"title"];
		[self addRule:nodeName forPattern:@"subtitle"];
		[self addRule:nodeName forPattern:@"content"];
		[self addRule:nodeName forPattern:@"summary"];
		[self addRule:nodeName forPattern:@"link"];

		[self addRule:nodeName forPattern:@"rss"];
		[self addRule:nodeName forPattern:@"guid"];
		[self addRule:nodeName forPattern:@"description"];

		GVCXMLDigesterAttributeMapRule *textType = [[GVCXMLDigesterAttributeMapRule alloc] initWithKeysAndValues:@"type", @"textType", nil];
		[self addRule:textType forPattern:@"title"];
		[self addRule:textType forPattern:@"subtitle"];
		[self addRule:textType forPattern:@"content"];
		[self addRule:textType forPattern:@"summary"];
		[self addRule:textType forPattern:@"link"];
		[self addRule:textType forPattern:@"guid"];
		[self addRule:textType forPattern:@"description"];
		
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyText:@"textContent"] forPattern:@"title"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyText:@"textContent"] forPattern:@"subtitle"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyText:@"textContent"] forPattern:@"content"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyText:@"textContent"] forPattern:@"summary"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyText:@"textContent"] forPattern:@"description"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyText:@"textContent"] forPattern:@"guid"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyText:@"textContent"] forPattern:@"link"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyText:@"textContent"] forPattern:@"source"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyCDATA:@"textCDATA"] forPattern:@"title"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyCDATA:@"textCDATA"] forPattern:@"subtitle"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyCDATA:@"textCDATA"] forPattern:@"content"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyCDATA:@"textCDATA"] forPattern:@"summary"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyCDATA:@"textCDATA"] forPattern:@"description"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyCDATA:@"textCDATA"] forPattern:@"guid"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyCDATA:@"textCDATA"] forPattern:@"link"];
		[self addRule:[GVCXMLDigesterRule ruleForSetPropertyCDATA:@"textCDATA"] forPattern:@"source"];

		// create <link> rule
		[self addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCRSSLink"] forPattern:@"link"];
		[self addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCRSSLink"] forPattern:@"guid"];
		[self addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCRSSLink"] forPattern:@"source"];
		GVCXMLDigesterAttributeMapRule *linkAttributes = [[GVCXMLDigesterAttributeMapRule alloc] initWithKeysAndValues:
														 @"href", @"linkHref", 
														 @"rel", @"linkRel", 
														 @"hreflang", @"linkHreflang", 
														 @"title", @"linkTitle", 
														 @"length", @"linkLength",
														 @"isPermaLink", @"linkIsPermaLink", nil];
		[self addRule:linkAttributes forPattern:@"link"];
		[self addRule:linkAttributes forPattern:@"guid"];
		[self addRule:linkAttributes forPattern:@"source"];

		[self addRule:[GVCXMLDigesterRule ruleForParentChild:@"feedLink"] forPattern:@"^feed/link"];
		[self addRule:[GVCXMLDigesterRule ruleForParentChild:@"feedLink"] forPattern:@"^rss/channel/link"];
		[self addRule:[GVCXMLDigesterRule ruleForParentChild:@"entryLink"] forPattern:@"^feed/entry/link"];
		[self addRule:[GVCXMLDigesterRule ruleForParentChild:@"entryLink"] forPattern:@"^rss/channel/item/link"];
		[self addRule:[GVCXMLDigesterRule ruleForParentChild:@"entryLink"] forPattern:@"^rss/channel/item/guid"];
		[self addRule:[GVCXMLDigesterRule ruleForParentChild:@"feedTitle"] forPattern:@"^feed/title"];
		[self addRule:[GVCXMLDigesterRule ruleForParentChild:@"feedTitle"] forPattern:@"^rss/channel/title"];
		[self addRule:[GVCXMLDigesterRule ruleForParentChild:@"feedSubTitle"] forPattern:@"^feed/subtitle"];
		[self addRule:[GVCXMLDigesterRule ruleForParentChild:@"feedSubTitle"] forPattern:@"^rss/channel/description"];
		[self addRule:[GVCXMLDigesterRule ruleForParentChild:@"entryTitle"] forPattern:@"^feed/entry/title"];
		[self addRule:[GVCXMLDigesterRule ruleForParentChild:@"entryTitle"] forPattern:@"^rss/channel/item/title"];
		[self addRule:[GVCXMLDigesterRule ruleForParentChild:@"entryContent"] forPattern:@"^feed/entry/content"];
		[self addRule:[GVCXMLDigesterRule ruleForParentChild:@"entrySummary"] forPattern:@"^feed/entry/summary"];
		[self addRule:[GVCXMLDigesterRule ruleForParentChild:@"entrySummary"] forPattern:@"^rss/channel/item/description"];

		GVCFileWriter *out = [[GVCFileWriter alloc] initForFilename:@"/tmp/rss.digest" encoding:NSUTF8StringEncoding];
		GVCXMLGenerator *generator = [[GVCXMLGenerator alloc] initWithWriter:out andFormat:GVC_XML_GeneratorFormat_PRETTY];
		[self writeConfiguration:generator];
		[generator closeDocument];
	}
	
    return self;
}

@end
