//
//  GVCXMLDigesterRuleManager.m
//
//  Created by David Aspinall on 11-02-04.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "NSArray+GVCFoundation.h"
#import "NSDictionary+GVCFoundation.h"

#import "GVCXMLDigesterRuleManager.h"
#import "GVCXMLDigester.h"
#import "GVCXMLDigesterRule.h"
#import "GVCXMLGenerator.h"
#import "GVCStringWriter.h"

@interface GVCXMLDigesterRuleManager ()
@property (weak, readwrite, nonatomic) GVCXMLDigester *digester;
@property (strong, nonatomic) NSMutableDictionary *ruleset_patterns;
@property (strong, nonatomic) NSMutableDictionary *ruleset_paths;
@property (strong, nonatomic) NSMutableDictionary *ruleset_nodes;

@property (strong, nonatomic) NSMutableDictionary *patternCache;
@end


@implementation GVCXMLDigesterRuleManager

@synthesize digester;
@synthesize ruleset_patterns;
@synthesize ruleset_paths;
@synthesize ruleset_nodes;
@synthesize patternCache;

- (id)initForDigester:(GVCXMLDigester *)dgst
{
	self = [super init];
	if (self != nil) 
	{
		[self setRuleset_nodes:[NSMutableDictionary dictionaryWithCapacity:0]];
		[self setRuleset_paths:[NSMutableDictionary dictionaryWithCapacity:0]];
		[self setRuleset_patterns:[NSMutableDictionary dictionaryWithCapacity:0]];
		[self setPatternCache:[NSMutableDictionary dictionaryWithCapacity:0]];
		digester = dgst;
	}
	return self;
}

- (void)addRule:(GVCXMLDigesterRule *)rule forNodeName:(NSString *)node_name
{
	GVC_ASSERT( gvc_IsEmpty(node_name) == NO, @"Cannot add rule for empty node_name" );
	GVC_ASSERT( rule != nil, @"Cannot add nil rule" );
	
	NSMutableArray *array = [ruleset_nodes objectForKey:node_name];
	if ( array == nil )
	{
		array = [NSMutableArray arrayWithCapacity:1];
		[ruleset_nodes setObject:array forKey:node_name];
	}
	
	[rule setDigester:[self digester]];
	[array addObject:rule];
}

- (void)addRuleList:(NSArray *)ruleList forNodeName:(NSString *)node_name
{
	GVC_ASSERT( gvc_IsEmpty(node_name) == NO, @"Cannot add rule for empty node_name" );
	GVC_ASSERT( gvc_IsEmpty(ruleList) == NO, @"Cannot add empty list of rules" );
	
	for (GVCXMLDigesterRule *rule in ruleList)
	{
		[self addRule:rule forNodeName:node_name];
	}
}

- (void)addRule:(GVCXMLDigesterRule *)rule forNodePath:(NSString *)node_path
{
    GVC_ASSERT( gvc_IsEmpty(node_path) == NO, @"Cannot add rule for empty node_path" );
	GVC_ASSERT( rule != nil, @"Cannot add nil rule" );
	
	NSMutableArray *array = [ruleset_paths objectForKey:node_path];
	if ( array == nil )
	{
		array = [NSMutableArray arrayWithCapacity:1];
		[ruleset_paths setObject:array forKey:node_path];
	}
	
	[rule setDigester:[self digester]];
	[array addObject:rule];
}

- (void)addRuleList:(NSArray *)ruleList forNodePath:(NSString *)node_path
{
    GVC_ASSERT( gvc_IsEmpty(node_path) == NO, @"Cannot add rule for empty node_path" );
	GVC_ASSERT( gvc_IsEmpty(ruleList) == NO, @"Cannot add empty list of rules" );
	
	for (GVCXMLDigesterRule *rule in ruleList)
	{
		[self addRule:rule forNodePath:node_path];
	}
}

- (void)addRuleList:(NSArray *)ruleList forPattern:(NSString *)pattern
{
	GVC_ASSERT( gvc_IsEmpty(pattern) == NO, @"Cannot add rule for empty pattern" );
	GVC_ASSERT( gvc_IsEmpty(ruleList) == NO, @"Cannot add empty list of rules" );
	
	for (GVCXMLDigesterRule *rule in ruleList)
	{
		[self addRule:rule forPattern:pattern];
	}
}

- (void)addRule:(GVCXMLDigesterRule *)rule forPattern:(NSString *)pattern
{
	GVC_ASSERT( gvc_IsEmpty(pattern) == NO, @"Cannot add rule for empty pattern" );
	GVC_ASSERT( rule != nil, @"Cannot add nil rule" );
	
	NSMutableArray *array = [ruleset_patterns objectForKey:pattern];
	if ( array == nil )
	{
		array = [NSMutableArray arrayWithCapacity:1];
		[ruleset_patterns setObject:array forKey:pattern];
	}
	
	[rule setDigester:[self digester]];
	[array addObject:rule];
}

- (NSArray *)rulesForNodeName:(NSString *)node_name
{
	return [self rulesForNodeName:node_name inNamespace:nil];
}

- (NSArray *)rulesForNodeName:(NSString *)node_name inNamespace:(NSString *)namesp
{
	GVC_ASSERT( gvc_IsEmpty(node_name) == NO, @"Cannot evaluate an empty node path" );
	
	NSMutableArray *matches = [ruleset_nodes objectForKey:node_name];
	if (gvc_IsEmpty(namesp) == NO)
	{
		NSPredicate *nspTest = [NSPredicate predicateWithFormat:@"namespaceURI = %@", namesp];
		[matches filterUsingPredicate:nspTest];
	}
	
	return [matches gvc_ArrayOrderingByKey:GVC_PROPERTY(rulePriority) ascending:YES];
}

- (NSArray *)rulesForNodePath:(NSString *)node_path
{
	return [self rulesForNodePath:node_path inNamespace:nil];
}

- (NSArray *)rulesForNodePath:(NSString *)node_path inNamespace:(NSString *)namesp
{
	GVC_ASSERT( gvc_IsEmpty(node_path) == NO, @"Cannot evaluate an empty node path" );
	
	NSArray *matchingPaths = [[ruleset_paths allKeys] gvc_filterArrayForAccept:^BOOL(id item) {
		NSString *itemString = item;
        BOOL match = [node_path isEqualToString:itemString];
        if ((match == NO) && ([node_path length] >= [itemString length]))
        {
            NSUInteger point = [node_path length] - [itemString length];
            NSString *tail = [node_path substringFromIndex:point];
            match = [tail isEqualToString:itemString];
        }
        return match;
    }];
    
    NSMutableArray *matches = [NSMutableArray arrayWithCapacity:0];
    for (NSString *hitpath in matchingPaths )
    {
        NSArray *ruleList = [ruleset_paths objectForKey:hitpath];
        [matches addObjectsFromArray:ruleList];
    }

	if (gvc_IsEmpty(namesp) == NO)
	{
		NSPredicate *nspTest = [NSPredicate predicateWithFormat:@"namespaceURI = %@", namesp];
		[matches filterUsingPredicate:nspTest];
	}
	
	return [matches gvc_ArrayOrderingByKey:GVC_PROPERTY(rulePriority) ascending:YES];
}

- (NSArray *)rulesForMatch:(NSString *)node_path
{
	return [self rulesForMatch:node_path inNamespace:nil];
}

- (NSArray *)rulesForMatch:(NSString *)node_path inNamespace:(NSString *)namesp
{
	GVC_ASSERT( gvc_IsEmpty(node_path) == NO, @"Cannot evaluate an empty node path" );

    NSArray *cached = [patternCache objectForKey:node_path];
    if ( cached == nil )
    {
        NSMutableArray *matches = [NSMutableArray arrayWithCapacity:0];
        NSArray *allPatterns = [ruleset_patterns allKeys];
        for (NSString *pattern in allPatterns )
        {
            NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern]; 
            
            if ([test evaluateWithObject:node_path] == YES)
            {
                NSArray *ruleList = [ruleset_patterns objectForKey:pattern];
                [matches addObjectsFromArray:ruleList];
            } 
        }

        if ( gvc_IsEmpty(matches) == NO )
        {
            cached = [matches copy];
            [patternCache setObject:cached forKey:node_path];
        }
        else
        {
            [patternCache setObject:[NSArray array] forKey:node_path];
        }
    }
	
	if (gvc_IsEmpty(namesp) == NO)
	{
		NSPredicate *nspTest = [NSPredicate predicateWithFormat:@"namespaceURI = %@", namesp];
        cached = [cached filteredArrayUsingPredicate:nspTest];
	}
	
	return cached;
}

- (void)writeConfiguration:(GVCXMLGenerator *)outputGenerator
{
    if ( gvc_IsEmpty(ruleset_nodes) == NO )
    {
        [outputGenerator openElement:@"nodes"];
        
        NSArray *rulesets = [ruleset_nodes gvc_sortedKeys];
        for (NSString *pattern in rulesets)
        {
            [outputGenerator openElement:@"ruleset" inNamespace:nil withAttributeKeyValues:@"nodeName", pattern, nil];
            
            NSArray *rules = [ruleset_nodes objectForKey:pattern];
            for (GVCXMLDigesterRule *aRule in rules)
            {
                [aRule writeConfiguration:outputGenerator];
            }
            
            [outputGenerator closeElement];
        }
        [outputGenerator closeElement];
    }

    if ( gvc_IsEmpty(ruleset_paths) == NO )
    {
        [outputGenerator openElement:@"paths"];
        
        NSArray *rulesets = [ruleset_paths gvc_sortedKeys];
        for (NSString *pattern in rulesets)
        {
            [outputGenerator openElement:@"ruleset" inNamespace:nil withAttributeKeyValues:@"nodePath", pattern, nil];
            
            NSArray *rules = [ruleset_patterns objectForKey:pattern];
            for (GVCXMLDigesterRule *aRule in rules)
            {
                [aRule writeConfiguration:outputGenerator];
            }
            
            [outputGenerator closeElement];
        }
        [outputGenerator closeElement];
    }

    if ( gvc_IsEmpty(ruleset_patterns) == NO )
    {
        [outputGenerator openElement:@"patterns"];
        
        NSArray *rulesets = [ruleset_patterns gvc_sortedKeys];
        for (NSString *pattern in rulesets)
        {
            [outputGenerator openElement:@"ruleset" inNamespace:nil withAttributeKeyValues:@"pattern", pattern, nil];
            
            NSArray *rules = [ruleset_patterns objectForKey:pattern];
            for (GVCXMLDigesterRule *aRule in rules)
            {
                [aRule writeConfiguration:outputGenerator];
            }
            
            [outputGenerator closeElement];
        }
        [outputGenerator closeElement];
    }

}

- (NSString *)description
{
    GVCStringWriter *stringWriter = [[GVCStringWriter alloc] init];
    GVCXMLGenerator *generator = [[GVCXMLGenerator alloc] initWithWriter:stringWriter andFormat:GVC_XML_GeneratorFormat_PRETTY];
    [generator open];
    [self writeConfiguration:generator];
    [generator closeDocument];
    return [stringWriter string];
}

@end
