/*
 * GVCXMLTextNode.m
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCXMLTextNode.h"
#import "GVCXMLGenerator.h"

#import "GVCMacros.h"

@interface GVCXMLTextNode ()

@end

@implementation GVCXMLTextNode

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
	}
	
    return self;
}

/** XMLTextContainer */

- (void)appendText:(NSString *)value
{
	if ( value != nil )
	{
		if ( [self text] != nil )
			[self setText:GVC_SPRINTF( @"%@%@", [self text], value )];
		else
			[self setText:value];
	}
}

- (void)appendTextWithFormat:(NSString*)fmt, ...
{
	va_list argList;
	NSString *value = nil;
	
	// Process arguments, resulting in a format string
	va_start(argList, fmt);
	value = [[NSString alloc] initWithFormat:fmt arguments:argList];
	va_end(argList);
	
	if ( value != nil )
	{
		if ( [self text] != nil )
			[self setText:GVC_SPRINTF( @"%@%@", [self text], value )];
		else
			[self setText:value];
	}
}

- (NSString *)normalizedText
{
	return [self text];
}

- (void)generateOutput:(GVCXMLGenerator *)generator
{
	[generator openElement:[self localname] inNamespace:[self defaultNamespace]];
	if ( gvc_IsEmpty([self attributes]) == NO )
	{
		for ( id <GVCXMLAttributeContent>attr in [self attributes])
		{
			[generator appendAttribute:[attr localname] inNamespacePrefix:[[attr defaultNamespace] prefix] forValue:[attr attributeValue]];
		}
	}
	[generator writeText:[self text]];
	[generator closeElement];
}

@end
