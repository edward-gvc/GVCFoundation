//
//  DAXMLText.m
//
//  Created by David Aspinall on 03/02/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCXMLText.h"
#import "GVCXMLGenerator.h"

#import "GVCMacros.h"

/**
 * $Date: 2009-01-20 16:28:51 -0500 (Tue, 20 Jan 2009) $
 * $Rev: 121 $
 * $Author: david $
*/
@implementation GVCXMLText

- (id)init
{
	self = [super init];
	if (self != nil)
	{
	}
	return self;
}

-(GVC_XML_ContentType)xmlType
{
	return GVC_XML_ContentType_TEXT;
}

/** Implementation */
/** XMLTextContainer */
- (NSString *)text
{
	return text;
}

- (void)setText:(NSString *)value
{
	text = value;
}

- (void)appendText:(NSString *)value
{
	if ( value != nil )
	{
		if ( text != nil )
			[self setText:GVC_SPRINTF( @"%@%@", text, value )];
		else
			[self setText:value];
	}
}

- (void)appendTextWithFormat:(NSString*)fmt, ...
{
	va_list argList;
	NSString *value = nil;
	
	// Process arguments, resulting in a format string
	va_start(argList, fmt);
	value = [[NSString alloc] initWithFormat:fmt arguments:argList];
	va_end(argList);

	if ( value != nil )
	{
		if ( text != nil )
			[self setText:GVC_SPRINTF( @"%@%@", text, value )];
		else
			[self setText:value];
	}
}

- (NSString *)normalizedText
{
	return text;
}

- (NSString *)description
{
	return text;
}
@end
