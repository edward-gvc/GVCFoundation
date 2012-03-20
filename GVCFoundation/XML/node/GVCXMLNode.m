/*
 * GVCXMLNode.m
 * 
 * Created by David Aspinall on 12-03-13. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCXMLNode.h"
#import "GVCXMLAttribute.h"

#import "GVCFunctions.h"

@interface GVCXMLNode ()
@property (readwrite, strong, nonatomic) NSMutableArray *attributeArray;
@end

@implementation GVCXMLNode

@synthesize attributeArray;

- (id)init 
{
    self = [super init];
    if (self) 
	{
        [self setAttributeArray:[[NSMutableArray alloc] init]];
    }
    return self;
}

	// GVCXMLContent
-(GVC_XML_ContentType)xmlType
{
	return GVC_XML_ContentType_SIMPLE;
}

	// GVCXMLNamedContent
@synthesize localname;
@synthesize defaultNamespace;
- (NSString *)qualifiedName
{
	NSString *qName = [self localname];
	if ( [self defaultNamespace] != nil )
	{
		qName = [[self defaultNamespace] qualifiedNameInNamespace:[self localname]];
	}
	return qName;
}


	// GVCXMLAttributeContainer
- (NSArray *)attributes
{
	return [[self attributeArray] copy];
}

- (void)addAttribute:(id <GVCXMLAttributeContent>)attrb
{
	if ( attrb != nil ) 
	{
		[[self attributeArray] addObject:attrb];
	}
}

- (void)addAttribute:(NSString *)attrb withValue:(NSString *)attval inNamespace:(id <GVCXMLNamespaceDeclaration>)ns
{
	[self addAttribute:[[GVCXMLAttribute alloc] initWithName:attrb value:attval inNamespace:ns forType:GVC_XML_AttributeType_ENTIRY]];
}

- (void)addAttributesFromArray:(NSArray *)attArray
{
	if ( gvc_IsEmpty(attArray) == NO )
	{
		for (NSObject *obj in attArray )
		{
			if ( [obj conformsToProtocol:@protocol(GVCXMLAttributeContent)] == YES )
			{
				[self addAttribute:(id <GVCXMLAttributeContent>)obj];
			}
		}
	}
}

- (id <GVCXMLAttributeContent>)attributeForName:(NSString *)key
{
	id <GVCXMLAttributeContent> attrObject = nil;
	for (id <GVCXMLAttributeContent> obj in attributeArray )
	{
		if ( [[obj localname] isEqualToString:key] == YES )
		{
			attrObject = obj;
			break;
		}
	}
	return attrObject;
}

@end
