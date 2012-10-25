/*
 * GVCSOAPFault.m
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCSOAPFault.h"
#import "GVCXMLNamespace.h"

@interface GVCSOAPFault ()

@end

@implementation GVCSOAPFault

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
		[self setLocalname:@"Fault"];
	}
	
    return self;
}

@end

#pragma mark - GVCSOAPFaultCode
@implementation GVCSOAPFaultCode
- (id)init
{
	self = [super init];
	if ( self != nil )
	{
		[self setLocalname:@"faultcode"];
	}
	
    return self;
}
@end

#pragma mark - GVCSOAPFaultString
@implementation GVCSOAPFaultString
- (id)init
{
	self = [super init];
	if ( self != nil )
	{
		[self setLocalname:@"faultstring"];
	}
	
    return self;
}
@end
