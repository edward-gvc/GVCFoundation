/*
 * GVCSOAPEnvelope.m
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCSOAPEnvelope.h"
#import "GVCXMLNamespace.h"
#import "GVCSOAPHeader.h"
#import "GVCSOAPBody.h"
#import "GVCXMLGenerator.h"

GVC_DEFINE_STRVALUE(GVCSOAPEnvelope_elementname, Envelope);

@interface GVCSOAPEnvelope ()

@end

@implementation GVCSOAPEnvelope

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
		[self setLocalname:GVCSOAPEnvelope_elementname];
		[self setDefaultNamespace:[GVCXMLNamespace namespaceForPrefix:@"soapenv" andURI:@"http://schemas.xmlsoap.org/soap/envelope/"]];
	}
	
    return self;
}

#pragma mark - GVCXMLGenerator protocol
- (void)generateOutput:(GVCXMLGenerator *)generator
{
	[generator openElement:[self qualifiedName] inNamespace:[self defaultNamespace] withAttributes:nil];
	[generator declareNamespaceArray:[[self declaredNamespaces] allValues]];
	
	if ( [self body] != nil )
	{
		[[self body] generateOutput:generator];
	}
	[generator closeElement];
}


@end
