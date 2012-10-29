/*
 * GVCSOAPFaultstring.m
 * 
 * Created by David Aspinall on 2012-10-27. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCSOAPFaultstring.h"
#import "GVCXMLNamespace.h"
#import "GVCXMLGenerator.h"

GVC_DEFINE_STRVALUE(GVCSOAPFaultstring_elementname, faultstring);


@interface GVCSOAPFaultstring ()

@end

@implementation GVCSOAPFaultstring

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
		[self setLocalname:GVCSOAPFaultstring_elementname];
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
	[generator openElement:[self qualifiedName] inNamespace:[self defaultNamespace] withAttributes:nil];
	[generator declareNamespaceArray:[[self declaredNamespaces] allValues]];
	for ( NSString *attr in [self attributes])
	{
		NSString *value = [[self attributes] valueForKey:attr];
		[generator appendAttribute:attr forValue:value];
	}

	[generator writeText:[self text]];
	[generator closeElement];
}

@end
