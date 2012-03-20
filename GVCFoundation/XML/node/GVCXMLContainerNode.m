/*
 * GVCXMLContainerNode.m
 * 
 * Created by David Aspinall on 12-03-13. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCXMLContainerNode.h"

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
- (NSArray *)children
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


@end
