//
//  DAXMLAttribute.m
//
//  Created by David Aspinall on 14/09/08.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCXMLAttribute.h"
#import "GVCXMLGenerator.h"
#import "GVCFunctions.h"

#import "GVCMacros.h"

@implementation GVCXMLAttribute

@synthesize localname;
@synthesize attributeValue;
@synthesize defaultNamespace;
@synthesize type;

- init
{
	return [self initWithName:nil value:nil inNamespace:nil forType:GVC_XML_AttributeType_UNDECLARED];
}

- initWithName:(NSString *)n value:(NSString *)v
{
	return [self initWithName:n value:v forType:GVC_XML_AttributeType_UNDECLARED];
}

- initWithName:(NSString *)n value:(NSString *)v forType:(GVC_XML_AttributeType)t
{
	return [self initWithName:n value:v inNamespace:nil forType:GVC_XML_AttributeType_UNDECLARED];
}

- initWithName:(NSString *)n value:(NSString *)v inNamespace:(id <GVCXMLNamespaceDeclaration>)nspace forType:(GVC_XML_AttributeType)t
{
	self = [super init];
	if ( self != nil ) 
	{
		[self setName:n value:v inNamespace:nspace forType:t];
	}
	return self;
}

- (void)setName:(NSString *)n value:(NSString *)v inNamespace:(id <GVCXMLNamespaceDeclaration>)nspace forType:(GVC_XML_AttributeType)t
{
	[self setLocalname:n];
	[self setAttributeValue:v];
	[self setDefaultNamespace:nspace];
	[self setType:t];
}

-(GVC_XML_ContentType)xmlType
{
	return GVC_XML_ContentType_ATTRIBUTE;
}

- (NSString *)qualifiedName
{
	NSString *qName = [self localname];
	if ( [self defaultNamespace] != nil )
	{
		qName = [[self defaultNamespace] qualifiedNameInNamespace:[self localname]];
	}
	return qName;
}

- (NSString *)description
{
	return GVC_SPRINTF( @"%@=\"%@\"", [self qualifiedName], [self attributeValue] );
}

@end
