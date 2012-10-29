/*
 * GVCSOAPDocument.m
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCSOAPDocument.h"
#import "GVCSOAPFault.h"
#import "GVCSOAPEnvelope.h"
#import "GVCSOAPHeader.h"
#import "GVCSOAPBody.h"
#import "GVCXMLDocType.h"
#import "GVCXMLGenerator.h"

#import "GVCFunctions.h"
#import "GVCLogger.h"

#import "GVCStack.h"
#import "NSString+GVCFoundation.h"
#import "NSArray+GVCFoundation.h"


@interface GVCSOAPDocument ()

@end

@implementation GVCSOAPDocument

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		[self setNodeStack:[[GVCStack alloc] init]];
	}
	return self;
}

- (void)reset
{
	GVC_DBC_REQUIRE()
	
	// implementation
	[self setNodeStack:[[GVCStack alloc] init]];
	[super reset];
	
	GVC_DBC_ENSURE(
				   GVC_DBC_FACT_NOT_NIL([self nodeStack]);
				   GVC_DBC_FACT([[self nodeStack] count] == 0);
				   )
}

-(GVC_XML_ContentType)xmlType
{
	return GVC_XML_ContentType_CONTAINER;
}

- (id <GVCXMLContent>)addContent:(id <GVCXMLContent>) child
{
	[[self nodeStack] pushObject:child];
	return child;
}

- (NSArray *)contentArray
{
	return [[self nodeStack] allObjects];
}

- (NSString *)description
{
	NSMutableString *buffer = [NSMutableString stringWithFormat:@"<%@>", NSStringFromClass([self class])];
	
	if ( [self documentType] != nil )
	{
		[buffer appendFormat:@"\n%@", [[self documentType] description]];
	}
	
	NSArray *allChildren = [self contentArray];
	if ( gvc_IsEmpty(allChildren) == NO )
	{
		[buffer appendString:@"\n"];
		
		id <GVCXMLContent> child = nil;
		for (child in allChildren)
		{
			[buffer appendString:[child description]];
		}
	}
	[buffer appendString:@"\n"];
	return buffer;
}

#pragma mark - GVCXMLGenerator protocol
- (void)generateOutput:(GVCXMLGenerator *)generator
{
	[generator openDocumentWithDeclaration:NO andEncoding:NO];
	if ( [self documentType] != nil )
	{
		[[self documentType] generateOutput:generator];
	}
	
	NSArray *allChildren = [self contentArray];
	if ( gvc_IsEmpty(allChildren) == NO )
	{
		id <GVCXMLContent, GVCXMLGeneratorProtocol> child = nil;
		for (child in allChildren)
		{
			GVC_ASSERT([child conformsToProtocol:@protocol(GVCXMLGeneratorProtocol)], @"Does not generate output %@", child);
			[(id <GVCXMLGeneratorProtocol>)child generateOutput:generator];
		}
	}
	[generator closeDocument];
}


#pragma mark - SOAP
- (NSString *)nodeClassNameForElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
{
	NSString *nodeClassName = nil;
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_EMPTY(elementName);
					)
	
	// implementation
	nodeClassName = GVC_SPRINTF(@"GVCSOAP%@", [elementName gvc_StringWithCapitalizedFirstCharacter]);
	Class clazz = NSClassFromString(nodeClassName);
	if ((clazz == nil) || ([clazz isSubclassOfClass:[GVCXMLRecursiveNode class]] == NO))
	{
		nodeClassName = nil;
	}
	
	GVC_DBC_ENSURE( )
	
	return nodeClassName;
}

- (GVCSOAPEnvelope *)envelope
{
	GVCSOAPEnvelope *env = nil;
	NSArray *children = [self contentArray];
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_NIL(children);
					)
	
	// implementation
	NSArray *envArray = [children gvc_filterForClass:[GVCSOAPEnvelope class]];
	if ( gvc_IsEmpty(envArray) == NO)
	{
		env = [envArray lastObject];
	}
	
	GVC_DBC_ENSURE(
				   GVC_DBC_FACT([envArray count] <= 1);
				   )
	return env;
}

- (GVCSOAPBody *)body
{
	GVCSOAPEnvelope *envelope = [self envelope];
	return (envelope == nil ? nil : [envelope body]);
}

#pragma mark - convenient message construction
- (GVCXMLRecursiveNode *)addSOAPBodyContent:(GVCXMLRecursiveNode *)msg
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_NIL(msg);
					)
	
	// implementation
	GVCSOAPEnvelope *envelope = [self envelope];
	if ( [self envelope] == nil )
	{
		envelope = [[GVCSOAPEnvelope alloc] init];
		[self addContent:envelope];
	}
	
	GVCSOAPHeader *header = [envelope header];
	if ( header == nil)
	{
		header = [[GVCSOAPHeader alloc] init];
		[envelope setHeader:header];
	}
	
	GVCSOAPBody *body = [envelope body];
	if ( body == nil )
	{
		body = [[GVCSOAPBody alloc] init];
		[envelope setBody:body];
	}

	[body addContent:msg];
	
	GVC_DBC_ENSURE()

	return msg;
}

- (BOOL)isFault
{
	return ([self faultNode] == nil);
}

- (GVCSOAPFault *)faultNode
{
	NSArray *bodyContent = [[[self envelope] body] contentArray];
	
	NSArray *filtered = [bodyContent gvc_filterForClass:[GVCSOAPFault class]];
	return (gvc_IsEmpty(filtered) == NO ? [filtered lastObject] : nil);
}


@end
