//
//  GVCXMLParserDelegate.m
//
//  Created by David Aspinall on 10-12-21.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCXMLParserDelegate.h"
#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "NSString+GVCFoundation.h"

#import "GVCXMLDocument.h"
#import "GVCXMLDocType.h"
#import "GVCXMLNamespace.h"
#import "GVCXMLText.h"
#import "GVCXMLComment.h"
#import "GVCXMLProcessingInstructions.h"
#import "GVCXMLAttribute.h"

@implementation GVCXMLParserDelegate

@synthesize filename;
@synthesize sourceURL;
@synthesize xmlData;

@synthesize xmlError;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		status = GVC_XML_ParserDelegateStatus_INITIAL;
	}
	return self;
}

- (GVC_XML_ParserDelegateStatus)status
{
	return status;
}

/*
	reset the parser so it can be reused.
 */
- (void)resetParser
{
	elementNameStack = nil;
	namespaceStack = nil;
	declaredNamespaces = nil;
	currentTextBuffer = nil;
	xmlError = nil;
	
	status = GVC_XML_ParserDelegateStatus_INITIAL;
}


- (GVC_XML_ParserDelegateStatus)parse
{
	if ( status == GVC_XML_ParserDelegateStatus_INITIAL )
	{
		NSXMLParser *parser = nil;
		
		status = GVC_XML_ParserDelegateStatus_PROCESSING;
		
		if ( [self filename] != nil )
		{
			parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:[self filename]]];
		}
		else if ( sourceURL != nil )
		{
			parser = [[NSXMLParser alloc] initWithContentsOfURL:sourceURL];
		}
		else if ( xmlData != nil )
		{
			parser = [[NSXMLParser alloc] initWithData:xmlData];
		}
		else 
		{
			status = GVC_XML_ParserDelegateStatus_FAILURE;
		}
		
		if ( status < GVC_XML_ParserDelegateStatus_FAILURE )
		{
			[parser setDelegate:self];
			[parser setShouldResolveExternalEntities:NO];
			[parser setShouldReportNamespacePrefixes:YES];
			[parser setShouldProcessNamespaces:YES];

			
			BOOL success = [parser parse];
			status = ( success ? GVC_XML_ParserDelegateStatus_SUCCESS : GVC_XML_ParserDelegateStatus_FAILURE );
		}
	}
	return status;
}

- (NSString *)currentTextString
{
	return [NSString stringWithString:currentTextBuffer];
}


- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	GVC_ASSERT(elementNameStack == nil, @"Node stack already initialized" );
	GVC_ASSERT(namespaceStack == nil, @"Namespace stack already initialized" );
	
	elementNameStack = [[GVCStack alloc] init];
	namespaceStack = [[NSMutableDictionary alloc] init];
	declaredNamespaces = [[NSMutableArray alloc] init];
	currentTextBuffer = [[NSMutableString alloc] init];
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	GVC_ASSERT( elementNameStack != nil, @"No node stack for document" );
	GVC_ASSERT( [elementNameStack count] == 0, @"Node stack is not empty %@", elementNameStack );
	GVC_ASSERT( namespaceStack != nil, @"No namespace stack for document" );
	GVC_ASSERT( [namespaceStack count] == 0, @"Namespace stack is not empty %@", namespaceStack );
	GVC_ASSERT( [declaredNamespaces count] == 0, @"Namespaces declared but not assigned to nodes %@", declaredNamespaces);
	
}

- (void)parser:(NSXMLParser *)parser foundNotationDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID
{
	GVCLogInfo( @"foundNotationDeclarationWithName:%@ publicID:%@ systemID:%@", name, publicID, systemID );
}

- (void)parser:(NSXMLParser *)parser foundUnparsedEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID notationName:(NSString *)notationName
{
	GVCLogInfo( @"foundUnparsedEntityDeclarationWithName:%@ publicID:%@ systemID:%@ notationName:%@", name, publicID, systemID, notationName);
}


- (void)parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName forElement:(NSString *)elementName type:(NSString *)type defaultValue:(NSString *)defaultValue
{
	GVCLogInfo( @"foundAttributeDeclarationWithName:%@ forElement:%@ type:%@ defaultValue:%@", attributeName, elementName, type, defaultValue);
}


- (void)parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model
{
	GVCLogInfo( @"foundElementDeclarationWithName:%@ model:%@", elementName, model);
}


- (void)parser:(NSXMLParser *)parser foundInternalEntityDeclarationWithName:(NSString *)name value:(NSString *)value
{
	GVCLogInfo( @"foundInternalEntityDeclarationWithName:%@ value:%@", name, value);
}


- (void)parser:(NSXMLParser *)parser foundExternalEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID
{
	GVCLogInfo( @"foundExternalEntityDeclarationWithName:%@ publicID:%@ systemID:%@", name, publicID, systemID );
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	[currentTextBuffer setString:[NSString gvc_EmptyString]];
	[elementNameStack pushObject:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	NSString *popName = [elementNameStack popObject];
	GVC_ASSERT([elementName isEqualToString:popName] == YES, @"end element %@ != %@ with stack %@", elementName, popName, elementNameStack );
}

- (void)parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI
{
	id <GVCXMLNamespaceDeclaration>namespace = [namespaceStack objectForKey:prefix];
	
	GVC_ASSERT( namespace == nil, @"Namespace prefix already in use [%@] as %@", prefix, namespace );
		
	// should this be an error?
	if ( namespace == nil )
	{
		namespace = [GVCXMLNamespace namespaceForPrefix:prefix andURI:namespaceURI];
		[namespaceStack setObject:namespace forKey:prefix];
		
		[declaredNamespaces addObject:namespace];
	}
}

- (void)parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix
{
	id <GVCXMLNamespaceDeclaration>namespace = [namespaceStack objectForKey:prefix];
	GVC_ASSERT( namespace != nil, @"Namespace prefix NOT in use [%@] as %@", prefix, namespace );
	[namespaceStack removeObjectForKey:prefix];
	[declaredNamespaces removeObject:namespace];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	[currentTextBuffer appendString:string];
}

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString
{
		//GVCLogInfo( @"foundIgnorableWhitespace:%@", whitespaceString);
}

- (void)parser:(NSXMLParser *)parser foundProcessingInstructionWithTarget:(NSString *)target data:(NSString *)data
{
		//GVCLogInfo( @"foundProcessingInstructionWithTarget:%@ data:%@", target, data);
}

- (void)parser:(NSXMLParser *)parser foundComment:(NSString *)comment
{
		//GVCLogInfo( @"foundComment:%@", comment);
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
		//GVCLogInfo( @"foundCDATA:%@", [CDATABlock descriptionFromOffset:0 limitingToByteCount:64]);
}

- (NSData *)parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)name systemID:(NSString *)systemID
{
		//GVCLogInfo( @"resolveExternalEntityName:%@ systemID:%@", name, systemID);
	return nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	GVCLogInfo( @"parseErrorOccurred (line %d:%d) %@", [parser lineNumber], [parser columnNumber], parseError);
	GVCLogInfo( @"parseErrorOccurred - node stack %@", elementNameStack );
	status = GVC_XML_ParserDelegateStatus_PARSE_FAILED;
	[self setXmlError:parseError];
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
	GVCLogInfo( @"validationErrorOccurred:%@", validationError);
	status = GVC_XML_ParserDelegateStatus_VALIDATION_FAILED;
	[self setXmlError:validationError];
}


@end
