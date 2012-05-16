//
//  GVCXMLParseNodeDelegate.m
//
//  Created by David Aspinall on 10-12-21.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCXMLParseNodeDelegate.h"

#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "GVCLogger.h"
#import "GVCStack.h"
#import "NSString+GVCFoundation.h"
#import "NSData+GVCFoundation.h"

#import "GVCXMLDocument.h"
#import "GVCXMLGenericNode.h"
#import "GVCXMLDocType.h"
#import "GVCXMLNamespace.h"
#import "GVCXMLText.h"
#import "GVCXMLComment.h"
#import "GVCXMLProcessingInstructions.h"
#import "GVCXMLAttribute.h"

@implementation GVCXMLParseNodeDelegate

@synthesize filename;
@synthesize sourceURL;
@synthesize xmlData;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		status = GVC_XML_ParserDelegateStatus_INITIAL;
	}
	return self;
}

/*
 reset the parser so it can be reused.
 GVCStack *nodeStack;
 NSMutableDictionary *namespaceStack;
 NSMutableArray *declaredNamespaces;
 
 NSString *filename;
 NSURL *sourceURL;
 NSData *xmlData;	
 
 id <GVCXMLDocumentNode> documentNode;
 GVC_XML_ParserDelegateStatus status;

 */
- (void)resetParser
{
	nodeStack = nil;
	namespaceStack = nil;
	declaredNamespaces = nil;
	filename = nil;
	sourceURL = nil;
	xmlData = nil;
	documentNode = nil;
	
	status = GVC_XML_ParserDelegateStatus_INITIAL;
}


- (GVC_XML_ParserDelegateStatus)status
{
	return status;
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

//***************** thing for subclasses
- (Class)documentClass
{
	return [GVCXMLDocument class];
}

- (Class)documentTypeClass
{
	return [GVCXMLDocType class];
}

- (Class)attributeClass
{
	return [GVCXMLAttribute class];
}

- (Class)namespaceClass
{
	return [GVCXMLNamespace class];
}

- (Class)commentClass
{
	return [GVCXMLComment class];
}

- (Class)processingInstructionClass
{
	return [GVCXMLProcessingInstructions class];
}
//**********************************


- (id <GVCXMLDocumentNode>)document
{
	GVC_ASSERT(status == GVC_XML_ParserDelegateStatus_SUCCESS, @"Parse failed, no document" );
	return documentNode;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
//	GVCLogInfo( @"Parser did start document" );
	GVC_ASSERT(nodeStack == nil, @"Node stack already initialized" );
	GVC_ASSERT(namespaceStack == nil, @"Namespace stack already initialized" );
	GVC_ASSERT(documentNode == nil, @"Document already initialized" );
	
	documentNode = [[[self documentClass] alloc] init];
	nodeStack = [[GVCStack alloc] init];
	namespaceStack = [[NSMutableDictionary alloc] init];
	declaredNamespaces = [[NSMutableArray alloc] init];
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
//	GVCLogInfo( @"Parser did end document" );
	GVC_ASSERT( nodeStack != nil, @"No node stack for document" );
	GVC_ASSERT( [nodeStack count] == 0, @"Node stack is not empty %@", nodeStack );
	GVC_ASSERT( namespaceStack != nil, @"No namespace stack for document" );
	GVC_ASSERT( [namespaceStack count] == 0, @"Namespace stack is not empty %@", namespaceStack );
	GVC_ASSERT( [declaredNamespaces count] == 0, @"Namespaces declared but not assigned to nodes %@", declaredNamespaces);
	
}

- (void)parser:(NSXMLParser *)parser foundNotationDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID
{
//	GVCLogInfo( @"foundNotationDeclarationWithName:%@ publicID:%@ systemID:%@", name, publicID, systemID );
}

- (void)parser:(NSXMLParser *)parser foundUnparsedEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID notationName:(NSString *)notationName
{
//	GVCLogInfo( @"foundUnparsedEntityDeclarationWithName:%@ publicID:%@ systemID:%@ notationName:%@", name, publicID, systemID, notationName);
}


- (void)parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName forElement:(NSString *)elementName type:(NSString *)type defaultValue:(NSString *)defaultValue
{
//	GVCLogInfo( @"foundAttributeDeclarationWithName:%@ forElement:%@ type:%@ defaultValue:%@", attributeName, elementName, type, defaultValue);
}


- (void)parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model
{
//	GVCLogInfo( @"foundElementDeclarationWithName:%@ model:%@", elementName, model);
}


- (void)parser:(NSXMLParser *)parser foundInternalEntityDeclarationWithName:(NSString *)name value:(NSString *)value
{
//	GVCLogInfo( @"foundInternalEntityDeclarationWithName:%@ value:%@", name, value);
}


- (void)parser:(NSXMLParser *)parser foundExternalEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID
{
//	GVCLogInfo( @"foundExternalEntityDeclarationWithName:%@ publicID:%@ systemID:%@", name, publicID, systemID );
	id <GVCXMLDocumentTypeDeclaration> docType = [[[self documentTypeClass] alloc] init];
	[docType setElementName:name publicID:publicID systemID:systemID forInternalSubset:nil];
	
	[documentNode setDocumentType:docType];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
//	GVCLogInfo( @"didStartElement:%@ namespaceURI:%@ qualifiedName:%@ attributes:%@", elementName, namespaceURI, qName, attributeDict );
	NSMutableArray *attArray = nil;
	if ( gvc_IsEmpty(attributeDict) == NO )
	{
		attArray = [NSMutableArray arrayWithCapacity:[attributeDict count]];
		Class attrClass = [self attributeClass];
		
		NSEnumerator *dEnum = [attributeDict keyEnumerator];
		NSString *key = nil;
		while ((key = [dEnum nextObject]) != nil)
		{
			NSString *val = [attributeDict objectForKey:key];
			NSString *local = [key gvc_XMLLocalNameFromQualifiedName];
			NSString *prefix = [key gvc_XMLPrefixFromQualifiedName];
			id <GVCXMLNamespaceDeclaration> namespace = nil;
			if ( prefix != nil )
			{
				namespace = [namespaceStack objectForKey:prefix];
			}
			
			id <GVCXMLAttributeContent>anAttribute = [[attrClass alloc] init];
			[anAttribute setDefaultNamespace:namespace];
			[anAttribute setLocalname:local];
			[anAttribute setAttributeValue:val];
			
			[attArray addObject:anAttribute];
		}
	}
	
	id <GVCXMLContent> content = [nodeStack peekObject];
	if ((content != nil) && ([content conformsToProtocol:@protocol(GVCXMLContainerNode)] == NO))
	{
		/** pop the TextContainer */
		[nodeStack popObject];
		content = [nodeStack peekObject];
	}
	
	if ( content == nil )
		content = documentNode;

	GVCXMLGenericNode *newChild = [[GVCXMLGenericNode alloc] init];
	[newChild setLocalname:elementName];
	//[newChild setDefaultNamespace:<#(id<GVCXMLNamespaceDeclaration>)#>
	[newChild addAttributesFromArray:attArray];
//	id <GVCXMLContent> newChild = [(id <GVCXMLContainerNode>)content addContentNodeFor:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attArray];
	
	if ([newChild conformsToProtocol:@protocol(GVCXMLNamedNode)] == YES)
	{
		for (id <GVCXMLNamespaceDeclaration>nspace in declaredNamespaces)
		{
			[(id <GVCXMLNamedNode>)newChild addDeclaredNamespace:nspace];
		}
		[declaredNamespaces removeAllObjects];
	}
	
	if ( newChild != nil )
		[nodeStack pushObject:newChild];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//	GVCLogInfo( @"didEndElement:%@ namespaceURI:%@ qualifiedName:%@", elementName, namespaceURI, qName);
	id <GVCXMLContent> content = [nodeStack peekObject];
	if ((content != nil) && ([content conformsToProtocol:@protocol(GVCXMLNamedNode)] == NO))
	{
		/** pop the TextContainer */
		[nodeStack popObject];
		content = [nodeStack peekObject];
	}

	id <GVCXMLNamedNode> node = (id <GVCXMLNamedNode>)content;
	if ( [[node localname] isEqualToString:elementName] == YES )
	{
		[nodeStack popObject];
	}
}

- (void)parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI
{
//	GVCLogInfo( @"didStartMappingPrefix:%@ toURI:%@", prefix, namespaceURI);
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
//	GVCLogInfo( @"didEndMappingPrefix:%@", prefix);
	id <GVCXMLNamespaceDeclaration>namespace = [namespaceStack objectForKey:prefix];
	
	GVC_ASSERT( namespace != nil, @"Namespace prefix NOT in use [%@] as %@", prefix, namespace );
	if ( namespace != nil )
	{
		[namespaceStack removeObjectForKey:prefix];
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
//	GVCLogInfo( @"foundCharacters:%@", string);
	string = [string gvc_TrimWhitespace];
	
	if ( gvc_IsEmpty(string) == NO )
	{
		id <GVCXMLTextContent> container = nil;
		if ( [[nodeStack peekObject] conformsToProtocol:@protocol(GVCXMLTextContent)] == YES )
		{
			container = [nodeStack peekObject];
		}
		else if ( [[nodeStack peekObject] conformsToProtocol:@protocol(GVCXMLContainerNode)] == YES )
		{
			container = [[GVCXMLText alloc] init];
			[(id <GVCXMLContainerNode>)[nodeStack peekObject] addContent:container];
			[nodeStack pushObject:container];
		}
		else
		{
			GVC_ASSERT( NO, @"unable to add text to %@", nodeStack );
		}
		
		[container appendText:string];
	}
	
}

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString
{
//	GVCLogInfo( @"foundIgnorableWhitespace:%@", whitespaceString);
}

- (void)parser:(NSXMLParser *)parser foundProcessingInstructionWithTarget:(NSString *)target data:(NSString *)data
{
//	GVCLogInfo( @"foundProcessingInstructionWithTarget:%@ data:%@", target, data);
	id <GVCXMLProcessingInstructionsNode> node = [[[self processingInstructionClass] alloc] init];
	[node setTarget:target];
	[node setData:data];
	
	id <GVCXMLContent> content = [nodeStack peekObject];
	if ((content != nil) && ([content conformsToProtocol:@protocol(GVCXMLContainerNode)] == NO))
	{
		/** pop the TextContainer */
		[nodeStack popObject];
		content = [nodeStack peekObject];
	}
	
	if ( content == nil )
		content = documentNode;
	
	[(id <GVCXMLContainerNode>)content addContent:node];
}

- (void)parser:(NSXMLParser *)parser foundComment:(NSString *)comment
{
//	GVCLogInfo( @"foundComment:%@", comment);
	id <GVCXMLCommentNode> node = [[[self commentClass] alloc] init];
	[node setText:comment];

	id <GVCXMLContent> content = [nodeStack peekObject];
	if ((content != nil) && ([content conformsToProtocol:@protocol(GVCXMLContainerNode)] == NO))
	{
		/** pop the TextContainer */
		[nodeStack popObject];
		content = [nodeStack peekObject];
	}
	
	if ( content == nil )
		content = documentNode;
	
	[(id <GVCXMLContainerNode>)content addContent:node];
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
//	GVCLogInfo( @"foundCDATA:%@", [CDATABlock gvc_descriptionFromOffset:0 limitingToByteCount:64]);
}

- (NSData *)parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)name systemID:(NSString *)systemID
{
//	GVCLogInfo( @"resolveExternalEntityName:%@ systemID:%@", name, systemID);
	return nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
//	GVCLogInfo( @"parseErrorOccurred:%@", parseError);
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
//	GVCLogInfo( @"validationErrorOccurred:%@", validationError);
}


@end
