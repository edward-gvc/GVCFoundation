/*
 * GVCXMLContainerNode.m
 * 
 * Created by David Aspinall on 12-03-13. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCXMLContainerNode.h"
#import "GVCXMLGenerator.h"
#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "GVCLogger.h"

@interface GVCXMLNode ()
@property (readwrite, strong, nonatomic) NSMutableArray *childArray;
@end

@implementation GVCXMLContainerNode

@synthesize childArray;

- (id)init 
{
    self = [super init];
    if (self) 
	{
        [self setChildArray:[[NSMutableArray alloc] init]];
    }
    return self;
}

	// GVCXMLContent
-(GVC_XML_ContentType)xmlType
{
	return GVC_XML_ContentType_CONTAINER;
}


	// GVCXMLContainerNode
- (NSArray *)contentArray
{
	return [[self childArray] copy];
}

- (id <GVCXMLContent>)addContent:(id <GVCXMLContent>) child
{
	if ( child != nil )
	{
		[[self childArray] addObject:child];
	}
	return child;
}

- (void)generateOutput:(GVCXMLGenerator *)generator
{
	[generator openElement:[self localname] inNamespace:[self defaultNamespace]];
	if ( gvc_IsEmpty([self attributes]) == NO )
	{
		for ( id <GVCXMLAttributeContent>attr in [self attributes])
		{
			[generator appendAttribute:[attr localname] inNamespacePrefix:[[attr defaultNamespace] prefix] forValue:[attr attributeValue]];
		}
	}

	if ( gvc_IsEmpty([self contentArray]) == NO )
	{
		id <GVCXMLContent> child = nil;
		for (child in [self contentArray])
		{
			GVC_ASSERT([child conformsToProtocol:@protocol(GVCXMLGeneratorProtocol)], @"Does not generate output %@", child);
			[(id <GVCXMLGeneratorProtocol>)child generateOutput:generator];
		}
	}

	[generator closeElement];
}

@end
