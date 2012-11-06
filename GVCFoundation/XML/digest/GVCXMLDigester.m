//
//  GVCXMLDigester.m
//
//  Created by David Aspinall on 11-02-04.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCXMLDigester.h"

#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "GVCStack.h"
#import "GVCStringWriter.h"
#import "GVCLogger.h"

#import "GVCXMLGenerator.h"
#import "GVCXMLDigesterRule.h"
#import "GVCXMLDigesterRuleManager.h"
#import "GVCXMLDigesterRuleset.h"
#import "GVCXMLDigesterAttributeMapRule.h"
#import "GVCXMLDigesterPairAttributeTextRule.h"

#import "NSDictionary+GVCFoundation.h"
#import "NSString+GVCFoundation.h"
#import "NSArray+GVCFoundation.h"

@interface GVCXMLDigester ()
@property (strong, nonatomic, readwrite) NSMutableDictionary *digestDictionary;
@property (strong, nonatomic) GVCXMLDigesterRuleManager *digestRuleManager;
@property (strong, nonatomic) GVCStack *currentNodeStack;
@end

@implementation GVCXMLDigester

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		[self setDigestRuleManager:[[GVCXMLDigesterRuleManager alloc] initForDigester:self]];
		[self resetParser];
	}
	return self;
}

+ (GVCXMLDigester *)digesterWithConfiguration:(NSString *)path
{
	GVCXMLDigester *newInstance = nil;
	GVCXMLDigester *irony = [[GVCXMLDigester alloc] init];
	[irony setXmlFilename:path];
	
	[irony addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCXMLDigester"] forNodeName:@"digester"];
	[irony addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCXMLDigesterRuleset"] forNodeName:@"ruleset"];
	[irony addRule:[GVCXMLDigesterRule ruleForCreateObjectFromAttribute:@"class_type"] forNodeName:@"rule"];
    
	[irony addRule:[GVCXMLDigesterRule ruleForParentChild:@"ruleset"]  forNodeName:@"ruleset"];
	[irony addRule:[GVCXMLDigesterRule ruleForParentChild:@"rule"]  forNodeName:@"rule"];
	
	GVCXMLDigesterAttributeMapRule *rulesetPatternRule = [[GVCXMLDigesterAttributeMapRule alloc] initWithKeysAndValues:@"pattern", @"pattern", @"nodeName", @"nodeName", @"nodePath", @"nodePath", nil];
	[irony addRule:rulesetPatternRule forNodeName:@"ruleset"];
	
	GVCXMLDigesterAttributeMapRule *attrRule = [[GVCXMLDigesterAttributeMapRule alloc] init];
	[attrRule setTryToAssignAll:YES];
	[irony addRule:attrRule forNodeName:@"rule"];
	
	GVCXMLDigesterPairAttributeTextRule *pairRule = [[GVCXMLDigesterPairAttributeTextRule alloc] initWithPropertyName:@"map" andAttributeName:@"attributeName"];
	[irony addRule:pairRule forNodeName:@"map"];
	
	[irony parse];
	if ([irony status] == GVCXMLParserDelegate_Status_SUCCESS )
	{
		newInstance = [irony digestValueForPath:@"digester"];
	}
	return newInstance;
}

- (NSArray *)digestKeys
{
    return [[self digestDictionary] allKeys];
}

- (id)digestValueForPath:(NSString *)key
{
	GVC_ASSERT_NOT_EMPTY( key );
	return [[self digestDictionary] valueForKey:key];
}

- (void)resetParser
{
	[super resetParser];
	
	[self setCurrentNodeStack:[[GVCStack alloc] init]];
	[self setDigestDictionary:[NSMutableDictionary dictionary]];
}

- (void)pushNodeObject:(id)anObject
{
	if ( [[self currentNodeStack] isEmpty] == YES )
	{
		NSString *epath = [self elementPath];
		if ( [[self digestDictionary] objectForKey:epath] != nil )
		{
			NSObject *value = [[self digestDictionary] objectForKey:epath];
			if ( [value isKindOfClass:[NSMutableArray class]] == YES )
				[(NSMutableArray *)value addObject:anObject];
			else
			{
				NSMutableArray *newValue = [NSMutableArray arrayWithObjects:value, anObject, nil];
				[[self digestDictionary] setObject:newValue forKey:[self elementPath]];
			}
		}
		else
		{
			[[self digestDictionary] setObject:anObject forKey:epath];
		}
	}
	
	[[self currentNodeStack] pushObject:anObject];
}

- (id)popNodeObject
{
	return [[self currentNodeStack] popObject];
}

- (id)peekNodeObject
{
	return [[self currentNodeStack] peekObject];
}

- (id)peekNodeObjectAtIndex:(NSUInteger)idx
{
	return [[self currentNodeStack] peekObjectAtIndex:idx];
}

- (NSString *)elementPath
{
	return [self elementFullpath:@"/"];
}

/**
 * returns the current text with whitespace trimed from the prefix and suffix .. or nil
 */
- (NSString *)currentTrimmedTextString
{
    NSString  *trimed = [[self currentTextBuffer] gvc_TrimWhitespaceAndNewline];
    return (gvc_IsEmpty(trimed) ? nil : trimed);
}

- (NSMutableArray *)rulesForCurrentPath
{
	// check for rules for the current path
	NSArray *path_rules = [[self digestRuleManager] rulesForNodePath:[self elementPath]];
	// check for rules for the current elementName
	NSArray *node_rules = [[self digestRuleManager] rulesForNodeName:[self peekTopElementName]];
	// check for patterns
	NSArray *pattern_rules = [[self digestRuleManager] rulesForMatch:[self elementPath]];
    NSMutableArray *rules = [NSMutableArray arrayWithCapacity:2];
    
    if ( gvc_IsEmpty(node_rules) == NO )
    {
        [rules addObjectsFromArray:node_rules];
    }
    if ( gvc_IsEmpty(path_rules) == NO )
    {
        [rules addObjectsFromArray:path_rules];
    }
    if ( gvc_IsEmpty(pattern_rules) == NO )
    {
        [rules addObjectsFromArray:pattern_rules];
    }
    return rules;
}

#pragma mark - NSXMLParserDelegate
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
	[self setCurrentCDATA:CDATABlock];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (gvc_IsEmpty(string) == NO)
	{
		[self setCurrentTextBuffer:GVC_SPRINTF(@"%@%@", [self currentTextBuffer], string)];
	}
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (gvc_IsEmpty([self currentTrimmedTextString]) == NO)
    {
        NSMutableArray *rules = [self rulesForCurrentPath];
        if ( gvc_IsEmpty(rules) == NO )
        {
            [rules gvc_sortWithOrderingKey:GVC_PROPERTY(rulePriority) ascending:YES];
            for (GVCXMLDigesterRule *rule in rules) 
            {
                [rule didFindCharacters:[self currentTrimmedTextString]];
            }
        }
    }
    
	[super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
	
    NSMutableArray *rules = [self rulesForCurrentPath];
    if ( gvc_IsEmpty(rules) == NO )
    {
        [rules gvc_sortWithOrderingKey:GVC_PROPERTY(rulePriority) ascending:YES];
		for (GVCXMLDigesterRule *rule in rules) 
		{
			if (gvc_IsEmpty([self currentTrimmedTextString]) == NO)
				[rule didFindCharacters:[self currentTrimmedTextString]];
			if (gvc_IsEmpty([self currentCDATA]) == NO)
				[rule didFindCDATA:[self currentCDATA]];
			[rule didStartElement:elementName attributes:attributeDict];
		}
	}
    else
    {
        GVCLogInfo(@"No digest rules for node %@", [self elementPath] );
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSMutableArray *rules = [self rulesForCurrentPath];
    if ( gvc_IsEmpty(rules) == NO )
    {
        [rules gvc_sortWithOrderingKey:GVC_PROPERTY(rulePriority) ascending:NO];
		for (GVCXMLDigesterRule *rule in rules)
		{
			if (gvc_IsEmpty([self currentTrimmedTextString]) == NO)
				[rule didFindCharacters:[self currentTrimmedTextString]];
			if (gvc_IsEmpty([self currentCDATA]) == NO)
				[rule didFindCDATA:[self currentCDATA]];
			[rule didEndElement:elementName];
		}
	}

	[self setCurrentCDATA:nil];
	[self setCurrentTextBuffer:nil];
	[super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
}

- (void)addRule:(GVCXMLDigesterRule *)rule forNodeName:(NSString *)node_name
{
	[[self digestRuleManager] addRule:rule forNodeName:node_name];
}

- (void)addRule:(GVCXMLDigesterRule *)rule forNodePath:(NSString *)node_name
{
	[[self digestRuleManager] addRule:rule forNodePath:node_name];
}

- (void) addRule:(GVCXMLDigesterRule *)rule forPattern:(NSString *)pattern
{
	[[self digestRuleManager] addRule:rule forPattern:pattern];
}

- (void)addRuleset:(GVCXMLDigesterRuleset *)set
{
    if ( gvc_IsEmpty([set nodeName]) == NO )
    {
        [[self digestRuleManager] addRuleList:[set rules] forNodeName:[set nodeName]];
    }
    else if ( gvc_IsEmpty([set nodePath]) == NO )
    {
        [[self digestRuleManager] addRuleList:[set rules] forNodePath:[set nodePath]];
    }
    else
    {
        [[self digestRuleManager] addRuleList:[set rules] forPattern:[set pattern]];
    }
}

- (NSString *)description
{
    GVCStringWriter *stringWriter = [[GVCStringWriter alloc] init];
    GVCXMLGenerator *generator = [[GVCXMLGenerator alloc] initWithWriter:stringWriter andFormat:GVC_XML_GeneratorFormat_PRETTY];
    [generator open];
	[generator openElement:@"digester"];
    [[self digestRuleManager] writeConfiguration:generator];
    
	[generator openElement:@"currentDigest"];
    if ( gvc_IsEmpty([self digestDictionary]) == NO )
    {
        [generator writeText:[[self digestDictionary] description]];
    }
	[generator closeElement];

    if ( [[self currentNodeStack] count] > 0 )
    {
        [generator openElement:@"currentNodeStack" inNamespace:nil withAttributeKeyValues:@"elementPath", [self elementPath]];
        [generator writeText:[[self currentNodeStack] description]];
        [generator closeElement];
    }

    [generator closeElement];
    
    [generator closeDocument];
    return [stringWriter string];
}

- (void)writeConfiguration:(GVCXMLGenerator *)outputGenerator
{
	[outputGenerator openDocumentWithDeclaration:YES andEncoding:YES];
	[outputGenerator openElement:@"digester"];
    [[self digestRuleManager] writeConfiguration:outputGenerator];
	[outputGenerator closeElement];
    [outputGenerator closeDocument];
}

@end
