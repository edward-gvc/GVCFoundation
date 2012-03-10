//
//  GVCXMLOutputNode.m
//  HL7ParseTest
//
//  Created by David Aspinall on 11-01-14.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCXMLOutputNode.h"
#import "GVCXMLNamespace.h"
#import "GVCMacros.h"

@implementation GVCXMLOutputNode

@synthesize nodeName;
@synthesize namespaces;
@synthesize attributes;

- (id)initWithName:(NSString *)n andAttributes:(NSArray *)a forNamespaces:(NSArray *)sp;
{
	self = [super init];
	if ( self != nil )
	{
		[self setNodeName:n];
		
		attributes = [a mutableCopy];
		namespaces = [sp mutableCopy];
	}
	return self;
}

- (void)addAttribute:(NSString *)key value:(id)value
{
	if ( attributes == nil )
	{
		attributes = [[NSMutableArray alloc] initWithCapacity:5];
	}

	[attributes addObject:[NSDictionary dictionaryWithObject:value forKey:key]];
}

- (void)addNamespace:(NSString *)prefix uri:(id)value
{
	[self addNamespace:[GVCXMLNamespace namespaceForPrefix:prefix andURI:value]];
}

- (void)addNamespace:(id <GVCXMLNamespaceDeclaration>)nmspValue
{
	if ( namespaces == nil )
	{
		namespaces = [[NSMutableArray alloc] initWithCapacity:5];
	}
	
	[namespaces addObject:nmspValue];
}

- (NSString *)description
{
	return GVC_SPRINTF( @"Node: <%@ />", nodeName );
}

@end
