/*
 * GVCSOAPSession.m
 * 
 * Created by David Aspinall on 2012-10-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCSOAPSession.h"
#import "GVCSOAPAction.h"

@interface GVCSOAPSession ()

@end

@implementation GVCSOAPSession

- (id)initForBaseURL:(NSURL *)url
{
	self = [super initForBaseURL:url];
	if ( self != nil )
	{
	}
	
    return self;
}

- (void)performAction:(GVCSOAPAction *)action completion:(GVCSessionActionCompleteBlock)block
{
	
}


@end
