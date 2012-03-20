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

#import "GVCXMLGenerator.h"
#import "GVCXMLDigesterRule.h"
#import "GVCXMLDigesterRuleManager.h"
#import "GVCXMLDigesterRuleset.h"
#import "GVCXMLDigesterAttributeMapRule.h"
#import "GVCXMLDigesterPairAttributeTextRule.h"

#import "NSDictionary+GVCFoundation.h"

@implementation GVCXMLDigester

@synthesize digest;
@synthesize digestRules;
@synthesize currentNodeStack;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		digestRules = [[GVCXMLDigesterRuleManager alloc] initForDigester:self];
		[self resetParser];
	}
	return self;
}

+ (GVCXMLDigester *)digesterWithConfiguration:(NSString *)path
{
	GVCXMLDigester *newInstance = nil;
	GVCXMLDigester *irony = [[GVCXMLDigester alloc] init];
	[irony setFilename:path];
	
	[irony addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCXMLDigester"] forPattern:@"^digester"];

	[irony addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCXMLDigesterRuleset"] forPattern:@"^digester/ruleset"];
	[irony addRule:[GVCXMLDigesterRule ruleForParentChild:@"ruleset"]  forPattern:@"^digester/ruleset"];
	
	GVCXMLDigesterAttributeMapRule *rulesetPatternRule = [[GVCXMLDigesterAttributeMapRule alloc] initWithKeysAndValues:@"pattern", @"pattern", nil];
	[irony addRule:rulesetPatternRule forPattern:@"^digester/ruleset"];
	
	[irony addRule:[GVCXMLDigesterRule ruleForCreateObjectFromAttribute:@"class_type"] forPattern:@"^digester/ruleset/rule"];
	[irony addRule:[GVCXMLDigesterRule ruleForParentChild:@"rule"]  forPattern:@"^digester/ruleset/rule"];
	GVCXMLDigesterAttributeMapRule *attrRule = [[GVCXMLDigesterAttributeMapRule alloc] init];
	[attrRule setTryToAssignAll:YES];
	[irony addRule:attrRule forPattern:@"^digester/ruleset/rule"];
	
	GVCXMLDigesterPairAttributeTextRule *pairRule = [[GVCXMLDigesterPairAttributeTextRule alloc] initWithPropertyName:@"map" andAttributeName:@"attributeName"];
	[irony addRule:pairRule forPattern:@"^digester/ruleset/rule/map"];
	
	[irony parse];
	if ([irony status] == GVC_XML_ParserDelegateStatus_SUCCESS )
	{
		newInstance = [[irony digest] valueForKey:@"digester"];
	}
	return newInstance;
}

- (id)digestValueForPath:(NSString *)key
{
	GVC_ASSERT_VALID_STRING( key );
	return [digest valueForKey:key];
}

- (void)resetParser
{
	[super resetParser];
	
	[self setCurrentNodeStack:[[GVCStack alloc] init]];
	[self setDigest:[NSMutableDictionary dictionary]];
}

- (void)pushNodeObject:(id)anObject
{
	if ( [currentNodeStack isEmpty] == YES )
	{
		NSString *epath = [self elementPath];
		if ( [digest objectForKey:epath] != nil )
		{
			NSObject *value = [digest objectForKey:epath];
			if ( [value isKindOfClass:[NSMutableArray class]] == YES )
				[(NSMutableArray *)value addObject:anObject];
			else
			{
				NSMutableArray *newValue = [NSMutableArray arrayWithObjects:value, anObject, nil];
				[digest setObject:newValue forKey:[self elementPath]];
			}
		}
		else
		{
			[digest setObject:anObject forKey:[self elementPath]];
		}
	}
	
	[currentNodeStack pushObject:anObject];
}

- (id)popNodeObject
{
	return [currentNodeStack popObject];
}

- (id)peekNodeObject
{
	return [currentNodeStack peekObject];
}

- (id)peekNodeObjectAtIndex:(NSUInteger)idx
{
	return [currentNodeStack peekObjectAtIndex:idx];
}

- (NSString *)elementPath
{
	return [[elementNameStack allObjects] componentsJoinedByString:@"/"];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	[super parserDidStartDocument:parser];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	[super parserDidEndDocument:parser];
	
	// TODO: loop through all rules and send [rule finishDigest];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	[super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
	
	// check for rules for the current elementName
	NSArray *rules = [digestRules rulesForNodeName:elementName];
	if (gvc_IsEmpty(rules) == NO) 
	{
		for (GVCXMLDigesterRule *rule in rules) 
		{
			[rule didStartElement:elementName attributes:attributeDict];
		}
	}
	
	// check for patterns
	rules = [digestRules rulesForMatch:[self elementPath]];
	if (gvc_IsEmpty(rules) == NO) 
	{
		for (GVCXMLDigesterRule *rule in rules) 
		{
			[rule didStartElement:elementName attributes:attributeDict];
		}
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	NSArray *rules = [digestRules rulesForMatch:[self elementPath]];
	if (gvc_IsEmpty(rules) == NO) 
	{
		for (GVCXMLDigesterRule *rule in [rules reverseObjectEnumerator])
		{
			if (gvc_IsEmpty([self currentTextString]) == NO)
				[rule didFindCharacters:[self currentTextString]];
			if (gvc_IsEmpty([self currentCDATA]) == NO)
				[rule didFindCDATA:[self currentCDATA]];
			[rule didEndElement:elementName];
		}
	}
	
	rules = [digestRules rulesForNodeName:elementName];
	if (gvc_IsEmpty(rules) == NO) 
	{
		for (GVCXMLDigesterRule *rule in [rules reverseObjectEnumerator])
		{
			if (gvc_IsEmpty([self currentTextString]) == NO)
				[rule didFindCharacters:[self currentTextString]];
			if (gvc_IsEmpty([self currentCDATA]) == NO)
				[rule didFindCDATA:[self currentCDATA]];
			[rule didEndElement:elementName];
		}
	}

	
	[super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
}

- (void) addRule:(GVCXMLDigesterRule *)rule forPattern:(NSString *)pattern
{
	[digestRules addRule:rule forPattern:pattern];
}

- (void)addRuleset:(GVCXMLDigesterRuleset *)set
{
	[digestRules addRuleList:[set rules] forPattern:[set pattern]];
}
					   
- (void)writeConfiguration:(GVCXMLGenerator *)outputGenerator
{
	[outputGenerator openDocumentWithDeclaration:YES andEncoding:YES];
	[outputGenerator openElement:@"digester"];
	
	NSArray *rulesets = [[digestRules ruleset] gvc_sortedKeys];
	for (NSString *pattern in rulesets)
	{
		[outputGenerator openElement:@"ruleset" inNamespace:nil withAttributeKeyValues:@"pattern", pattern, nil];
		
		NSArray *rules = [[digestRules ruleset] objectForKey:pattern];
		for (GVCXMLDigesterRule *aRule in rules)
		{
			[aRule writeConfiguration:outputGenerator];
		}
		
		[outputGenerator closeElement];
	}
	[outputGenerator closeElement];
	
}

@end
