/*
 * GVCSOAPFault.m
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCSOAPFault.h"
#import "GVCXMLNamespace.h"
#import "GVCXMLGenerator.h"
#import "GVCSOAPFaultcode.h"
#import "GVCSOAPFaultstring.h"

GVC_DEFINE_STRVALUE(GVCSOAPFault_elementname, Fault);

@interface GVCSOAPFault ()

@end

@implementation GVCSOAPFault

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
		[self setLocalname:GVCSOAPFault_elementname];
	}
	
    return self;
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

	if ( [self faultcode] != nil )
	{
		[[self faultcode] generateOutput:generator];
	}

	if ( [self faultstring] != nil )
	{
		[[self faultstring] generateOutput:generator];
	}
	[generator closeElement];
}

@end
