/*
 * GVCConfigProperty.m
 * 
 * Created by David Aspinall on 12-05-17. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCConfigProperty.h"
#import "GVCFunctions.h"
#import "GVCMacros.h"
#import "GVCXMLGenerator.h"

@implementation GVCConfigProperty

@synthesize action;
@synthesize name;
@synthesize value;

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
    [outputGenerator openElement:@"property" inNamespace:nil withAttributes:copyDict];
    [outputGenerator writeText:[self value]];
    [outputGenerator closeElement]; // property
}

@end
