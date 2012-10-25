/*
 * GVCSOAPAction.m
 * 
 * Created by David Aspinall on 2012-10-23. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCSOAPAction.h"
#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "GVCNetworking.h"

@interface GVCSOAPAction ()

@end

@implementation GVCSOAPAction

- (id)init
{
	return [self initWithActionName:GVC_CLASSNAME(self)];
}

- (id)initWithActionName:(NSString *)aName
{
	self = [super init];
	if ( self != nil )
	{
		[self setSoapActionName:aName];
	}
	
    return self;
}

@end
