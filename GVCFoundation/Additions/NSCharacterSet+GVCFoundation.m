//
//  NSCharacterSet+GVCFoundation.m
//
//  Created by David Aspinall on 11-01-13.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "NSCharacterSet+GVCFoundation.h"


@implementation NSCharacterSet (GVCFoundation)

static NSCharacterSet *XMLAttributeEscape;
static NSCharacterSet *XMLEntityEscapeWithQuot;
static NSCharacterSet *XMLEntityEscapeWithoutQuot;

+ (NSCharacterSet *)gvc_XMLAttributeCharacterEscapeSet
{
	// check the static variable to avoid MUTEX block if possible
	if ( XMLAttributeEscape == nil )
	{
		@synchronized (self)
		{
			// check again to avoid race conditions
			if ( XMLAttributeEscape == nil )
			{
				XMLAttributeEscape = [NSCharacterSet characterSetWithCharactersInString:@"<>\"&\r\n\t"];
			}
		}
	}
	return XMLAttributeEscape;
}

+ (NSCharacterSet *)gvc_XMLEntityCharacterEscapeSetWithoutQuote
{
	// check the static variable to avoid MUTEX block if possible
	if ( XMLEntityEscapeWithoutQuot == nil )
	{
		@synchronized (self)
		{
			// check again to avoid race conditions
			if (XMLEntityEscapeWithoutQuot == nil)
			{
				XMLEntityEscapeWithoutQuot = [NSCharacterSet characterSetWithCharactersInString:@"&<>"];
			}
		}
	}
	return XMLEntityEscapeWithoutQuot;
}

+ (NSCharacterSet *)gvc_XMLEntityCharacterEscapeSetWithQuote
{
	// check the static variable to avoid MUTEX block if possible
	if ( XMLEntityEscapeWithQuot == nil )
	{
		@synchronized (self)
		{
			// check again to avoid race conditions
			if (XMLEntityEscapeWithQuot == nil)
			{
				XMLEntityEscapeWithQuot = [NSCharacterSet characterSetWithCharactersInString:@"&<>\"'"];
			}
		}
	}
	return XMLEntityEscapeWithQuot;
}

+ (NSCharacterSet *)gvc_XMLEntityCharacterEscapeSet:(BOOL)withQuote
{
	if ( withQuote == YES )
		return [self gvc_XMLEntityCharacterEscapeSetWithQuote];
	
	return [self gvc_XMLEntityCharacterEscapeSetWithoutQuote];
}



@end
