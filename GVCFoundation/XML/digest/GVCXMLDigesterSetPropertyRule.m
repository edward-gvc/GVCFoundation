//
//  GVCXMLDigesterSetPropertyRule.m
//  HL7ParseTest
//
//  Created by David Aspinall on 11-02-05.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCXMLDigesterSetPropertyRule.h"

#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "GVCXMLGenerator.h"

#import "NSString+GVCFoundation.h"


@implementation GVCXMLDigesterSetPropertyRule

@synthesize propertyName;
@synthesize nodeText;

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
	self = [super init];
	if (self != nil) 
	{
		[self setPropertyName:pname];
	}
	return self;
}

- (void) didFindCharacters:(NSString *)text
{
    [self setNodeText:text];
}

- (void) didEndElement:(NSString *)elementName
{
    id object = [[self digester] peekNodeObject];
    [object setValue:nodeText forKey:(gvc_IsEmpty(propertyName) ? elementName : propertyName)];
}

- (void)writeConfiguration:(GVCXMLGenerator *)outputGenerator
{
	NSMutableDictionary *copyDict = [NSMutableDictionary dictionaryWithCapacity:2];
	[copyDict setObject:GVC_CLASSNAME(self) forKey:@"class_type"];
	[copyDict setObject:(gvc_IsEmpty(propertyName) == YES ? [NSString gvc_EmptyString] : propertyName) forKey:GVC_PROPERTY(propertyName)];
	
	[outputGenerator writeElement:@"rule" inNamespace:nil withAttributes:copyDict];
}

@end
