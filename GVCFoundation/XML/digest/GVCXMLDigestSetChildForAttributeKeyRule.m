//
//  GVCXMLDigestSetChildForAttributeKeyRule.m
//  GVCImmunization
//
//  Created by David Aspinall on 11-03-09.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCXMLDigestSetChildForAttributeKeyRule.h"

#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "NSString+GVCFoundation.h"

#import "GVCXMLGenerator.h"

@implementation GVCXMLDigestSetChildForAttributeKeyRule

@synthesize attributeName;

- (id) init
{
	self = [super init];
	if (self != nil) 
	{
	}
	return self;
}

- (id) initWithPropertyName:(NSString *)pname
{
	return [self initWithAttributeName:pname];
}

- (id) initWithAttributeName:(NSString *)pname
{
	self = [super init];
	if (self != nil) 
	{
		[self setAttributeName:pname];
	}
	return self;
}

- (void) didStartElement:(NSString *)element attributes:(NSDictionary *)attributeDict
{
	[self setPropertyName:[attributeDict objectForKey:attributeName]];
}

- (void)writeConfiguration:(GVCXMLGenerator *)outputGenerator
{
	NSMutableDictionary *copyDict = [NSMutableDictionary dictionaryWithCapacity:2];
	[copyDict setObject:GVC_CLASSNAME(self) forKey:@"class_type"];
	[copyDict setObject:(gvc_IsEmpty(attributeName) == YES ? [NSString gvc_EmptyString] : attributeName) forKey:GVC_PROPERTY(attributeName)];
	
	[outputGenerator writeElement:@"rule" inNamespace:nil withAttributes:copyDict];
}

@end