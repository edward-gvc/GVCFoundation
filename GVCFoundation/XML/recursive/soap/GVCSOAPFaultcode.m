/*
 * GVCSOAPFaultcode.m
 * 
 * Created by David Aspinall on 2012-10-27. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCSOAPFaultcode.h"
#import "GVCXMLNamespace.h"
#import "GVCXMLGenerator.h"

GVC_DEFINE_STRVALUE(GVCSOAPFaultcode_elementname, faultcode);


@interface GVCSOAPFaultcode ()

@end

@implementation GVCSOAPFaultcode

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
		[self setLocalname:GVCSOAPFaultcode_elementname];
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
	[generator writeText:[self text]];
	[generator closeElement];
}

@end
