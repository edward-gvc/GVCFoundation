/*
 * GVCSOAPDocument.m
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCSOAPDocument.h"
#import "GVCSOAPFault.h"

@interface GVCSOAPDocument ()

@end

@implementation GVCSOAPDocument

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
	}
	
    return self;
}


- (BOOL)isFault
{
	return ([self faultNode] == nil);
}

- (GVCSOAPFault *)faultNode
{
	return (GVCSOAPFault *)[self nodeForPath:@"Envelope/Body/Fault"];
}


@end
