/*
 * XSDParserDelegate.m
 * 
 * Created by David Aspinall on 2012-10-25. 
 * Copyright (c) 2012 Global Village. All rights reserved.
 *
 */

#import "GVCBaseParserDelegate.h"
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

@implementation GVCParseBase
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
	[self setElementStack:[[GVCStack alloc] init]];
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
	
	return [allElements gvc_componentsJoinedByString:separator after:^(id item) {
		NSString *elementName = nil;
		if ( [item isKindOfClass:[NSString class]] == YES )
		{
			elementName = (NSString *)item;
		}
		else
		{
			if ( [item conformsToProtocol:@protocol(GVCXMLNamedContent)] == YES )
			{
				elementName = [(id <GVCXMLNamedContent>)item localname];
			}
			else
			{
				elementName = [item description];
			}
		}
		return (NSString *)elementName;
    }];
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

/**************************************************/
@interface GVCParseNode ()
@property (strong, nonatomic) NSMutableString *stringBuffer;
@property (strong, nonatomic) NSMutableDictionary *localNamespaces;
@end

@implementation GVCParseNode
- (id)init
{
	self = [super init];
	if (self != nil)
	{
		[self setLocalNamespaces:[[NSMutableDictionary alloc] init]];
	}
	return self;
}
- (void)reset
{
	[self setLocalNamespaces:[[NSMutableDictionary alloc] init]];
}

- (NSString *)qualifiedName
{
	NSString *qName = nil;
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_EMPTY([self localname]);
					GVC_DBC_FACT( (([self namespacePrefix] == nil) || (gvc_IsEmpty([self namespacePrefix]) == NO)) );
					)
	
	// implementation
	if ( gvc_IsEmpty([self namespacePrefix]) == NO)
	{
		qName = GVC_SPRINTF(@"%@:%@", [self namespacePrefix], [self localname]);
	}
	else
	{
		qName = [self localname];
	}
	
	GVC_DBC_ENSURE(
				   GVC_DBC_FACT_NOT_EMPTY(qName);
				   )
	return qName;
}

- (id<GVCXMLNamespaceDeclaration>)defaultNamespace
{
	GVCXMLNamespace *namespace = nil;
	if ( gvc_IsEmpty([self namespacePrefix]) == NO)
	{
		namespace = [[self localNamespaces] objectForKey:[self namespacePrefix]];
	}
	return namespace;
}

- (BOOL)isNamespaceInScope:(NSString *)prefix
{
	BOOL inScope = NO;
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_NIL(prefix);
					)
	
	// implementation
	inScope = ([[self localNamespaces] objectForKey:prefix] != nil);
	if ((inScope == NO) && (([self parent] != nil) && [[self parent] isKindOfClass:[GVCParseNode class]] == YES) )
	{
		inScope = [(GVCParseNode *)[self parent] isNamespaceInScope:prefix];
	}
	
	GVC_DBC_ENSURE(
				   )

	return inScope;
}

- (NSDictionary *)declaredNamespaces
{
	return [[self localNamespaces] copy];
}

- (void)declareNamespace:(NSString *)prefix forURI:(NSString *)uri
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_EMPTY(uri);
					GVC_DBC_FACT_NOT_NIL([self localNamespaces]);
					)
	
	// implementation
	if ( gvc_IsEmpty(prefix) == YES)
	{
		prefix = [NSString gvc_EmptyString];
	}
	
	if ( [self isNamespaceInScope:prefix] == NO)
	{
		[[self localNamespaces] setObject:[GVCXMLNamespace namespaceForPrefix:prefix andURI:uri] forKey:prefix];
	}
	
	GVC_DBC_ENSURE(
				   )
}

- (NSString *)currentTextContent
{
	NSString  *trimed = [[self stringBuffer] gvc_TrimWhitespaceAndNewline];
    return (gvc_IsEmpty(trimed) ? nil : trimed);
}

- (NSString *)currentGetTextSelectorKey
{
	return [self peekTopElementName];
}

- (NSString *)currentSetTextSelectorKey
{
	NSString *defaultKey = [self peekTopElementName];
	NSString *valueSelector = GVC_SPRINTF(@"set%@:", [defaultKey gvc_StringWithCapitalizedFirstCharacter]);
	if ( [self respondsToSelector:NSSelectorFromString(valueSelector)] == NO )
	{
		valueSelector = GVC_SPRINTF(@"add%@:", [defaultKey gvc_StringWithCapitalizedFirstCharacter]);
		if ( [self respondsToSelector:NSSelectorFromString(valueSelector)] == NO )
		{
			GVC_ASSERT(NO, @"unable to find selector %@ on this object %@", defaultKey, self);
		}
	}
	
	return valueSelector;
}

- (NSString *)currentGetNodeSelectorKey
{
	return [self peekTopElementName];
}

- (NSString *)currentSetNodeSelectorKey
{
	NSString *defaultKey = [self peekTopElementName];
	NSString *valueSelector = GVC_SPRINTF(@"set%@:", [defaultKey gvc_StringWithCapitalizedFirstCharacter]);
	if ( [self respondsToSelector:NSSelectorFromString(valueSelector)] == NO )
	{
		valueSelector = GVC_SPRINTF(@"add%@:", [defaultKey gvc_StringWithCapitalizedFirstCharacter]);
		if ( [self respondsToSelector:NSSelectorFromString(valueSelector)] == NO )
		{
			GVC_ASSERT(NO, @"unable to find selector %@ on this object %@", defaultKey, self);
		}
	}
	
	return valueSelector;
}


#pragma mark - NSXMLParser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	NSString *currentText = [self currentTextContent];
    if (gvc_IsEmpty(currentText) == NO)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		[self performSelector:NSSelectorFromString([self currentSetTextSelectorKey]) withObject:currentText];
#pragma clang diagnostic pop
		[self setStringBuffer:[NSMutableString string]];
    }
	[super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	NSString *currentText = [self currentTextContent];
    if (gvc_IsEmpty(currentText) == NO)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		[self performSelector:NSSelectorFromString([self currentSetTextSelectorKey]) withObject:currentText];
#pragma clang diagnostic pop
		[self setStringBuffer:[NSMutableString string]];
    }
	[super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
}

- (void)parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI
{
	// implementation
	//	GVCLogInfo( @"didStartMappingPrefix:%@ toURI:%@", prefix, namespaceURI);
	[self declareNamespace:prefix forURI:namespaceURI];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT([[self elementStack] count] > 0);
					)
	
	// implementation
	string = [string gvc_TrimWhitespace];
	if ( gvc_IsEmpty(string) == NO )
	{
		if ( [self stringBuffer] == nil )
		{
			[self setStringBuffer:[[NSMutableString alloc] initWithCapacity:[string length]]];
		}

		[[self stringBuffer] appendString:string];
	}
	
	GVC_DBC_ENSURE(
	)
}

#pragma mark - output
- (NSString *)description
{
	GVCStringWriter *writer = [[GVCStringWriter alloc] init];
	[self generateOutput:[[GVCXMLGenerator alloc] initWithWriter:writer]];
	return [writer string];
}

- (void)generateOutput:(GVCXMLGenerator *)generator
{
	[generator writeElement:GVC_CLASSNAME(self) inNamespace:[GVCXMLNamespace namespaceForPrefix:@"gvc" andURI:@"http://ww.global-village.net"] withAttributeKeyValues:@"Smoke", @"Mirrors", nil];
}

@end
/**************************************************/

@interface GVCBaseParserDelegate ()
@property (assign, nonatomic, readwrite) GVCXMLParserDelegate_Status status;
@end


@implementation GVCBaseParserDelegate

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		[self setStatus:GVCXMLParserDelegate_Status_INITIAL];
		[self setElementStack:[[GVCStack alloc] init]];
	}
	return self;
}

- (BOOL)isReady
{
    BOOL ready = NO;
	if ( [self status] == GVCXMLParserDelegate_Status_INITIAL )
    {
        if (([self xmlFilename] != nil) || ([self xmlSourceURL] != nil) || ([self xmlData] != nil))
        {
            ready = YES;
        }
    }
    return ready;
}

- (void)reset
{
	[super reset];
	[self setXmlFilename:nil];
	[self setXmlSourceURL:nil];
	[self setXmlData:nil];
	[self setXmlError:nil];
	[self setStatus:GVCXMLParserDelegate_Status_INITIAL];
}

- (GVCXMLParserDelegate_Status)parse:(NSXMLParser *)parser
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_NIL(parser);
					GVC_DBC_FACT([self status] == GVCXMLParserDelegate_Status_INITIAL);
					)
	
	[self setStatus:GVCXMLParserDelegate_Status_PROCESSING];
	
	[parser setDelegate:self];
	[parser setShouldResolveExternalEntities:NO];
	[parser setShouldReportNamespacePrefixes:YES];
	[parser setShouldProcessNamespaces:YES];
	
	BOOL success = [parser parse];
	[self setStatus:( success ? GVCXMLParserDelegate_Status_SUCCESS : GVCXMLParserDelegate_Status_FAILURE )];
	
	GVC_DBC_ENSURE(
				   GVC_DBC_FACT([self status] != GVCXMLParserDelegate_Status_INITIAL);
				   )
	
	return [self status];
}

- (GVCXMLParserDelegate_Status)parse
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT( ([self xmlFilename] != nil) || ([self xmlSourceURL] != nil) || ([self xmlData] != nil) );
					GVC_DBC_FACT([self status] == GVCXMLParserDelegate_Status_INITIAL);
					)
	
	if ( gvc_IsEmpty([self xmlFilename]) == NO )
	{
		[self parse:[[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:[self xmlFilename]]]];
	}
	else if ( [self xmlSourceURL] != nil )
	{
		[self parse:[[NSXMLParser alloc] initWithContentsOfURL:[self xmlSourceURL]]];
	}
	else if ( [self xmlData] != nil )
	{
		[self parse:[[NSXMLParser alloc] initWithData:[self xmlData]]];
	}
	else
	{
		[self setXmlError:[NSError errorWithDomain:@"GVCXMLParsingDomain" code:-1 userInfo:@{ @"reason" : @"No input source"}]];
		[self setStatus:GVCXMLParserDelegate_Status_FAILURE];
	}
	
	GVC_DBC_ENSURE(
				   GVC_DBC_FACT([self status] != GVCXMLParserDelegate_Status_INITIAL);
				   )
	
	return [self status];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	//	GVCLogInfo( @"parseErrorOccurred:%@", parseError);
	[self setXmlError:parseError];
	[self setStatus:GVCXMLParserDelegate_Status_PARSE_FAILED];
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
	//	GVCLogInfo( @"validationErrorOccurred:%@", validationError);
	[self setXmlError:validationError];
	[self setStatus:GVCXMLParserDelegate_Status_VALIDATION_FAILED];
}

@end
