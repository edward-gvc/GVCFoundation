//
//  GVCXMLDigesterRuleset.m
//  HL7ParseTest
//
//  Created by David Aspinall on 11-02-06.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCXMLDigesterRuleset.h"
#import "GVCXMLDigesterRule.h"


@implementation GVCXMLDigesterRuleset

@synthesize pattern;
@synthesize rules;

- (void)addRule:(GVCXMLDigesterRule *)aRule
{
	if ( rules == nil )
		[self setRules:[NSMutableArray arrayWithCapacity:1]];
	
	[rules addObject:aRule];
}

@end

