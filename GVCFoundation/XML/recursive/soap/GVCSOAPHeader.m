/*
 * GVCSOAPHeader.m
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCSOAPHeader.h"
#import "GVCXMLNamespace.h"
#import "GVCXMLGenerator.h"

GVC_DEFINE_STRVALUE(GVCSOAPHeader_elementname, Header);

@interface GVCSOAPHeader ()

@end

@implementation GVCSOAPHeader

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
		[self setLocalname:GVCSOAPHeader_elementname];
		[self setDefaultNamespace:[GVCXMLNamespace namespaceForPrefix:@"soapenv" andURI:@"http://schemas.xmlsoap.org/soap/envelope/"]];
	}
	
    return self;
}

- (void)generateOutput:(GVCXMLGenerator *)generator
{
	[generator openElement:[self qualifiedName] inNamespace:[self defaultNamespace] withAttributes:nil];
	[generator declareNamespaceArray:[[self declaredNamespaces] allValues]];
	
	[generator closeElement];
}

@end
