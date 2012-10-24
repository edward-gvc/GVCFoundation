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
	return [self initWithContent:nil];
}

- (id)initWithContent:(NSString *)string;
{
	self = [super init];
	if (self != nil)
	{
		[self setText:string];
	}
	return self;
}

-(GVC_XML_ContentType)xmlType
{
	return GVC_XML_ContentType_TEXT;
}

/** Implementation */
/** XMLTextContainer */

- (void)appendText:(NSString *)value
{
	if ( value != nil )
	{
		if ( [self text] != nil )
			[self setText:GVC_SPRINTF( @"%@%@", [self text], value )];
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
		if ( [self text] != nil )
			[self setText:GVC_SPRINTF( @"%@%@", [self text], value )];
		else
			[self setText:value];
	}
}

- (NSString *)normalizedText
{
	return [self text];
}

- (NSString *)description
{
	return [self text];
}
@end
