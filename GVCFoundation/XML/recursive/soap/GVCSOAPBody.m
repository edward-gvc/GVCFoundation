/*
 * GVCSOAPBody.m
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCSOAPBody.h"
#import "GVCXMLNamespace.h"
#import "GVCXMLGenerator.h"
#import "GVCStack.h"

GVC_DEFINE_STRVALUE(GVCSOAPBody_elementname, Body);

@interface GVCSOAPBody ()
@property (strong, nonatomic) NSMutableArray *nodeArray;
@end

@implementation GVCSOAPBody

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
		[self setLocalname:GVCSOAPBody_elementname];
		[self setDefaultNamespace:[GVCXMLNamespace namespaceForPrefix:@"soapenv" andURI:@"http://schemas.xmlsoap.org/soap/envelope/"]];
		[self setNodeArray:[[NSMutableArray alloc] init]];
	}
	
    return self;
}

- (id <GVCXMLContent>)addContent:(id <GVCXMLContent>) child
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_NIL(child);
					)
	
	// implementation
	if ( [self nodeArray] == nil )
	{
		[self setNodeArray:[[NSMutableArray alloc] init]];
	}
	
	[[self nodeArray] addObject:child];

	return child;
}

- (NSArray *)contentArray
{
	return [self nodeArray];
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

	for ( GVCXMLRecursiveNode *node in [self nodeArray])
	{
		[node generateOutput:generator];
	}
	[generator closeElement];
}

@end
