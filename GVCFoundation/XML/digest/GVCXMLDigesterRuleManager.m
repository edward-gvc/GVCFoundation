//
//  GVCXMLDigesterRuleManager.m
//
//  Created by David Aspinall on 11-02-04.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "GVCMacros.h"
#import "GVCFunctions.h"

#import "GVCXMLDigesterRuleManager.h"
#import "GVCXMLDigester.h"
#import "GVCXMLDigesterRule.h"

@interface GVCXMLDigesterRuleManager ()
@property (weak, readwrite, nonatomic) GVCXMLDigester *digester;
@end


@implementation GVCXMLDigesterRuleManager

@synthesize digester;
@synthesize ruleset;

- (id)initForDigester:(GVCXMLDigester *)dgst
{
	self = [super init];
	if (self != nil) 
	{
		[self setRuleset:[NSMutableDictionary dictionaryWithCapacity:0]];
		digester = dgst;
	}
	return self;
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
	
	NSMutableArray *array = [ruleset objectForKey:pattern];
	if ( array == nil )
	{
		array = [NSMutableArray arrayWithCapacity:1];
		[ruleset setObject:array forKey:pattern];
	}
	
	[rule setDigester:[self digester]];
	[array addObject:rule];
}

- (NSArray *)match:(NSString *)node_path
{
	return [self match:node_path inNamespace:nil];
}

- (NSArray *)match:(NSString *)node_path inNamespace:(NSString *)namesp
{
	GVC_ASSERT( gvc_IsEmpty(node_path) == NO, @"Cannot evaluate an empty node path" );

	NSMutableArray *matches = [NSMutableArray arrayWithCapacity:0];
	NSArray *allPatterns = [ruleset allKeys];
	for (NSString *pattern in allPatterns )
	{
		NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern]; 
		
		if ([test evaluateWithObject:node_path] == YES)
		{
			NSArray *ruleList = [ruleset objectForKey:pattern];
			[matches addObjectsFromArray:ruleList];
		} 
	}
	
	if (gvc_IsEmpty(namesp) == NO)
	{
		NSPredicate *nspTest = [NSPredicate predicateWithFormat:@"namespaceURI = %@", namesp];
		[matches filterUsingPredicate:nspTest];
	}
	
	return matches;
}

@end
