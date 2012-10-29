/*
 * GVCXMLRecursiveParserBase.m
 * 
 * Created by David Aspinall on 2012-10-27. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCXMLRecursiveParserBase.h"
#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "GVCStack.h"
#import "GVCLogger.h"
#import "GVCStringWriter.h"

#import "GVCXMLNamespace.h"
#import "GVCXMLGenerator.h"

#import "NSString+GVCFoundation.h"
#import "NSData+GVCFoundation.h"
#import "NSArray+GVCFoundation.h"


@interface GVCXMLRecursiveParserBase ()

@end

@implementation GVCXMLRecursiveParserBase

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		[self setElementStack:[[GVCStack alloc] init]];
	}
	return self;
}

- (void)reset
{
	GVC_DBC_REQUIRE()
	
	// implementation
	[self setElementStack:[[GVCStack alloc] init]];
	
	GVC_DBC_ENSURE(
				   GVC_DBC_FACT_NOT_NIL([self elementStack]);
				   GVC_DBC_FACT([[self elementStack] count] == 0);
				   )
}

#pragma mark - node peeking
- (NSString *)peekTopElementName
{
	GVC_DBC_REQUIRE(
	)
	
	// implementation
	NSObject *top = [[self elementStack] peekObject];
	if ( [top isKindOfClass:[NSString class]] == NO )
	{
		if ( [top conformsToProtocol:@protocol(GVCXMLNamedContent)] == YES )
		{
			top = [(id <GVCXMLNamedContent>)top localname];
		}
		else
		{
			top = [top description];
		}
	}
	return (NSString *)top;
}

- (NSString *)elementNamePath:(NSString *)separator
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_NIL([self elementStack]);
					GVC_DBC_FACT_NOT_EMPTY(separator);
					)
	NSArray *allElements = [[self elementStack] allObjects];
	NSString *path = nil;
	if ( gvc_IsEmpty(allElements) == NO )
	{
		path = [allElements componentsJoinedByString:separator];
	}
	return path;
}

- (NSString *)fullElementNamePath:(NSString *)separator
{
	NSString *current = [self elementNamePath:separator];
	NSString *parentPath = nil;
	if ( [self parent] != nil )
	{
		parentPath = [[self parent] fullElementNamePath:separator];
	}
	
	if (gvc_IsEmpty(parentPath) == NO)
	{
		if  (gvc_IsEmpty(current) == NO )
		{
			current = GVC_SPRINTF(@"%@%@%@", parentPath, separator, current );
		}
		else
		{
			current = parentPath;
		}
	}
	return current;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	[[self elementStack] pushObject:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	[[self elementStack] popObject];
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	if ( [self parent] != nil )
	{
		[[self parent] parser:parser parseErrorOccurred:parseError];
	}
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
	if ( [self parent] != nil )
	{
		[[self parent] parser:parser validationErrorOccurred:validationError];
	}
}

@end
