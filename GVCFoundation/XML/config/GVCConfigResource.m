/*
 * GVCConfigResource.m
 * 
 * Created by David Aspinall on 12-05-17. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCConfigResource.h"
#import "GVCFunctions.h"
#import "GVCMacros.h"
#import "GVCXMLGenerator.h"

@implementation GVCConfigResource

@synthesize action;
@synthesize name;
@synthesize tag;
@synthesize md5;
@synthesize status;

@synthesize path;

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
	NSMutableDictionary *copyDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [copyDict setObject:[self name] forKey:@"name"];
    if ( gvc_IsEmpty([self action]) == NO )
    {
        [copyDict setObject:[self action] forKey:@"action"];
    }
    if ( gvc_IsEmpty([self tag]) == NO )
    {
        [copyDict setObject:[self tag] forKey:@"tag"];
    }
    if ( gvc_IsEmpty([self md5]) == NO )
    {
        [copyDict setObject:[self md5] forKey:@"md5"];
    }
    if ( gvc_IsEmpty([self status]) == NO )
    {
        [copyDict setObject:[self status] forKey:@"status"];
    }

    [outputGenerator openElement:@"resource" inNamespace:nil withAttributes:copyDict];
    if ( gvc_IsEmpty([self path]) == NO )
    {
        [outputGenerator writeText:[self path]];
    }
    [outputGenerator closeElement]; // resource
}

@end
