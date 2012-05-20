/*
 * GVCConfigObject.m
 * 
 * Created by David Aspinall on 12-05-17. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCConfigObject.h"
#import "GVCFunctions.h"
#import "GVCMacros.h"
#import "GVCXMLGenerator.h"

@implementation GVCConfigObject

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
	}
	
    return self;
}

- (void)writeConfiguration:(GVCXMLGenerator *)outputGenerator
{
	[outputGenerator writeElement:GVC_CLASSNAME(self) withText:[self description]];
}

@end
