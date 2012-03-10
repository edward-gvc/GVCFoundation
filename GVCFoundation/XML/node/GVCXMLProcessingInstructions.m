//
//  DAXMLProcessingInstructions.m
//
//  Created by David Aspinall on 04/02/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCXMLProcessingInstructions.h"
#import "GVCXMLParsingModel.h"
#import "GVCXMLGenerator.h"

#import "GVCMacros.h"
#import "NSString+GVCFoundation.h"

/**
 * $Date: 2009-01-20 16:28:51 -0500 (Tue, 20 Jan 2009) $
 * $Rev: 121 $
 * $Author: david $
*/
@implementation GVCXMLProcessingInstructions

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
	return GVC_XML_ContentType_PROCESSING;
}

/** Implementation */

// XMLProcessingInstructions
- (NSString *)target
{
	return target;
}

- (NSString *)data
{
	return data;
}

- (void)setTarget:(NSString *)v
{
	target = v;
}

- (void)setData:(NSString *)v
{
	data = v;
}

- (NSString *)description
{
	return GVC_SPRINTF( @"<?%@%@%@?>", target, (data == nil?[NSString gvc_EmptyString]:@" "), (data == nil?[NSString gvc_EmptyString]:data));
}

@end
