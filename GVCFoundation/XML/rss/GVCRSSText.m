/*
 * GVCRSSText.m
 * 
 * Created by David Aspinall on 12-03-15. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCRSSText.h"
#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "GVCXMLGenerator.h"

#import "NSData+GVCFoundation.h"

@implementation GVCRSSText

@synthesize textType;
@synthesize textContent;
@synthesize textCDATA;

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
	}
	
    return self;
}

- (NSString *)description
{
	return GVC_SPRINTF(@"%@ <%@ type='%@'> %@", GVC_CLASSNAME(self), [self nodeName], [self textType], [self textContent]);
}

- (BOOL)hasContent
{
	return ((gvc_IsEmpty(textContent) == NO) || (gvc_IsEmpty(textCDATA) == NO));
}

- (void)writeRss:(GVCXMLGenerator *)outputGenerator
{
	NSMutableDictionary *attributes = nil;
	if ( gvc_IsEmpty(textType) == NO )
	{
		attributes = [[NSMutableDictionary alloc] init];
		[attributes setValue:[self textType] forKey:@"type"];
	}

	[outputGenerator openElement:[self nodeName] inNamespace:nil withAttributes:attributes];
	if ( gvc_IsEmpty( textContent ) == NO )
		[outputGenerator writeText:[self textContent]];
	
	if ( gvc_IsEmpty( textCDATA ) == NO )
	{
		[outputGenerator writeCDATA:[[NSString alloc] initWithData:textCDATA encoding:NSUTF8StringEncoding]];
//		if ((gvc_IsEmpty(textType) == YES) || ([@"text" isEqualToString:textType] ==YES))
//		{
//			[outputGenerator writeCDATA:[[NSString alloc] initWithData:textCDATA encoding:NSUTF8StringEncoding]];
//		}
//		else
//			[outputGenerator writeCDATA:[textCDATA gvc_base64Encoded]];
	}
	
	[outputGenerator closeElement];
}

@end
