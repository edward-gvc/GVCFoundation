/*
 * GVCNetworkSession.m
 * 
 * Created by David Aspinall on 2012-10-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCNetworkSession.h"
#import <GVCFoundation/GVCFoundation.h>

@interface GVCNetworkSession ()
@property (strong, nonatomic, readwrite) NSURL *baseURL;
@end

@implementation GVCNetworkSession

- (id)init
{
	return [self initForBaseURL:nil];
}

- (id)initForBaseURL:(NSURL *)url
{
	self = [super init];
	if ( self != nil )
	{
		GVC_DBC_FACT_NOT_NIL(url);
		GVC_DBC_FACT_NOT_EMPTY([url absoluteString]);
		
		[self setBaseURL:url];
	}
	return self;
}

@end
