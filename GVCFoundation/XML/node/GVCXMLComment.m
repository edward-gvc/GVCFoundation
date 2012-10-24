//
//  DAXMLComment.m
//
//  Created by David Aspinall on 04/02/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCXMLComment.h"
#import "GVCXMLGenerator.h"

#import "GVCMacros.h"

/**
 * $Date: 2009-01-20 16:28:51 -0500 (Tue, 20 Jan 2009) $
 * $Rev: 121 $
 * $Author: david $
*/
@implementation GVCXMLComment

- (id)init
{
	return [self initWithComment:nil];
}

- (id)initWithComment:(NSString *)cmt
{
	self = [super initWithContent:cmt];
	if (self != nil)
	{
	}
	return self;
}

-(GVC_XML_ContentType)xmlType
{
	return GVC_XML_ContentType_COMMENT;
}

/** Implementation */

- (NSString *)description
{
	return GVC_SPRINTF( @"<!-- %@ -->", [self text]);
}

@end
