/*
 * GVCHTTPSession.m
 * 
 * Created by David Aspinall on 2012-10-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCHTTPSession.h"

@interface GVCHTTPSession ()

@end

@implementation GVCHTTPSession

- (id)initForBaseURL:(NSURL *)url
{
	self = [super initForBaseURL:url];
	if ( self != nil )
	{
	}
	
    return self;
}


- (void)performAction:(GVCHTTPAction *)action completion:(GVCSessionActionCompleteBlock)block
{
	
}

@end
