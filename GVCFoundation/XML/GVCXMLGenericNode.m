//
//  DAXMLNode.m
//
//  Created by David Aspinall on 02/02/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCXMLGenericNode.h"
#import "GVCXMLNamespace.h"
#import "GVCXMLAttribute.h"
#import "GVCXMLGenerator.h"

#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "NSString+GVCFoundation.h"

@interface GVCXMLGenericNode ()
@property (strong, nonatomic) NSMutableDictionary *attributesDict;
@property (strong, nonatomic) NSMutableArray *nodeArray;
@property (strong, nonatomic) NSMutableArray *declaredNamespaces;
@end

@implementation GVCXMLGenericNode

@synthesize defaultNamespace;
@synthesize localname;

@synthesize attributesDict;
@synthesize nodeArray;
@synthesize declaredNamespaces;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
	}
	return self;
}

- (NSArray *)children
{
	return [nodeArray copy];
}

-(GVC_XML_ContentType)xmlType
{
	return GVC_XML_ContentType_CONTAINER;
}


- (NSString *)description
{
	NSMutableString *buffer = [NSMutableString stringWithFormat:@"<%@", [self qualifiedName]];
	
	if ( defaultNamespace != nil )
	{
		[buffer appendString:@" "];
		[buffer appendString:[defaultNamespace description]];
	}

	if ( declaredNamespaces != nil )
	{
		id <GVCXMLNamespaceDeclaration> decl = nil;
		for ( decl in declaredNamespaces)
		{
			[buffer appendString:@" "];
			[buffer appendString:[decl description]];
		}
	}
	
	if ( attributesDict != nil )
	{
		NSString *attrKey = nil;
		for ( attrKey in attributesDict)
		{
			id <GVCXMLAttributeContent>attr = [attributesDict objectForKey:attrKey];
			[buffer appendString:@" "];
			[buffer appendString:[attr description]];
		}
	}
	
	if ( nodeArray != nil )
	{
		[buffer appendString:@">"];
		id <GVCXMLContent> node = nil;
		for ( node in nodeArray)
		{
			if ( [node conformsToProtocol:@protocol(GVCXMLContainerNode)] == YES )
				[buffer appendString:@"\n"];
				
			[buffer appendString:[node description]];
		}
		[buffer appendFormat:@"</%@>\n", [self qualifiedName]];
	}
	else
	{
		[buffer appendString:@" />\n"];
	}
	return buffer;
}

/** Implementation */

	// XMLNamedContent
- (NSArray *)attributes
{
	return [attributesDict allValues];
}

- (void)addAttribute:(id <GVCXMLAttributeContent>)attrb
{
	if ( attrb != nil )
	{
		if ( attributesDict == nil )
		{
			attributesDict = [[NSMutableDictionary alloc] init];
		}
		
		[attributesDict setObject:attrb forKey:[attrb qualifiedName]];
	}
}

- (void)addAttribute:(NSString *)attrb withValue:(NSString *)attval inNamespace:(id <GVCXMLNamespaceDeclaration>)ns
{
	if ( attrb != nil )
	{
		id <GVCXMLAttributeContent> attribute = [[GVCXMLAttribute alloc] initWithName:attrb value:attval inNamespace:ns forType:GVC_XML_AttributeType_UNDECLARED];
		[self addAttribute:attribute];
	}
}

- (id <GVCXMLAttributeContent>)attributeForName:(NSString *)key
{
	return [attributesDict objectForKey:key];
}

- (void)addAttributesFromArray:(NSArray *)attArray
{
	if ( gvc_IsEmpty(attArray) == NO )
	{
		for (id anAtt in attArray)
		{
			GVC_ASSERT( [[anAtt class] conformsToProtocol:@protocol(GVCXMLAttributeContent)] == YES, @"Attribute [%@] does not conform to protocol", anAtt );
			[self addAttribute:(id <GVCXMLAttributeContent>)anAtt];
		}
	}
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


- (id <GVCXMLContent>)addContent:(id <GVCXMLContent>) child
{
	if ( nodeArray == nil )
	{
		nodeArray = [[NSMutableArray alloc] init];
	}
	
	[nodeArray addObject:child];
	return child;
}

- (id <GVCXMLContent>)addContentNodeFor:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSArray *)attributeList
{
	GVCXMLGenericNode *node = [[GVCXMLGenericNode alloc] init];
	[node setLocalname:elementName];
	[node addAttributesFromArray:attributeList];
	
	if (gvc_IsEmpty(namespaceURI) == NO) 
	{
		[node setDefaultNamespace:[GVCXMLNamespace namespaceForPrefix:[qName gvc_XMLPrefixFromQualifiedName] andURI:namespaceURI]];
	}

	return [self addContent:node];
}

- (void)addDeclaredNamespace:(id <GVCXMLNamespaceDeclaration>)v
{
	if ([defaultNamespace isEqual:v] == NO)
	{
		if ( declaredNamespaces == nil )
		{
			declaredNamespaces = [[NSMutableArray alloc] init];
		}
		
		if ([declaredNamespaces containsObject:v] == NO)
		{
			[declaredNamespaces addObject:v];	
		}
	}
}

- (NSArray *)declaredNamespaces
{
	return declaredNamespaces;
}

@end
