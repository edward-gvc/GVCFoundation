//
//  DAXMLNamespace.m
//
//  Created by David Aspinall on 14/09/08.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCXMLNamespace.h"
#import "GVCXMLGenerator.h"
#import "GVCFunctions.h"
#import "NSString+GVCFoundation.h"

@implementation GVCXMLNamespace

+ (id <GVCXMLNamespaceDeclaration>)namespaceForPrefix:(NSString *)pfx andURI:(NSString *)u;
{
    return [[self alloc] initWithPrefix:pfx uri:u];
}

- initWithPrefix:(NSString *)name uri:(NSString *)u
{
	self = [super initWith:(name == nil ? [NSString gvc_EmptyString] : name) and:u];
	if ( self != nil ) 
	{
	}
	return self;
}

-(GVC_XML_ContentType)xmlType
{
	return GVC_XML_ContentType_NAMESPACE;
}

- (NSString *)prefix
{
	return [self left];
}

- (NSString *)uri
{
	return [self right];
}

- (NSString *)qualifiedPrefix
{
	NSMutableString *buffer = [NSMutableString stringWithCapacity:10];
	[buffer appendString:@"xmlns"];
	if ( gvc_IsEmpty([self prefix]) == NO )
	{
		[buffer appendFormat:@":%@", [self prefix]];
	}
	return buffer;
}

- (NSString *)qualifiedNameInNamespace:(NSString *)localname;
{
	GVC_ASSERT(gvc_IsEmpty(localname) == NO, @"No local name provided" );
	NSMutableString *buffer = [NSMutableString stringWithCapacity:10];
    NSString *prefix = [self prefix];
    if ((prefix != nil) && ([prefix length] > 0))
    {
        [buffer appendString:prefix];
        [buffer appendString:@":"];
    }
	[buffer appendString:localname];
	return buffer;
}

- (NSString *)description
{
	return GVC_SPRINTF( @"%@=\"%@\"", [self qualifiedPrefix], [self uri] );
}
@end
