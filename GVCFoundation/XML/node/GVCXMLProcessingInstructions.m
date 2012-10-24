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
	return [self initTarget:nil forData:nil];
}

- (id)initTarget:(NSString *)targt forData:(NSString *)dta;
{
	self = [super init];
	if (self != nil)
	{
		[self setTarget:targt];
		[self setData:dta];
	}
	return self;
}

-(GVC_XML_ContentType)xmlType
{
	return GVC_XML_ContentType_PROCESSING;
}

/** Implementation */

- (NSString *)description
{
	NSString *dtaInst = gvc_IsEmpty([self data]) ? [NSString gvc_EmptyString] : GVC_SPRINTF(@" %@", [self data]);
	return GVC_SPRINTF( @"<?%@%@?>", [self target], dtaInst);
}

@end
