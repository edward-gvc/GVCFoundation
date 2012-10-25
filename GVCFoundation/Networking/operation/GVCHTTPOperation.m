/*
 * GVCHTTPOperation.m
 * 
 * Created by David Aspinall on 12-03-21. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCHTTPOperation.h"
#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "GVCLogger.h"
#import "GVCNetworking.h"

@implementation GVCHTTPOperation

@synthesize acceptableStatusCodes;
@synthesize acceptableContentTypes;

- (id)initForRequest:(NSURLRequest *)req
{
	self = [super initForRequest:req];
	if ( self != nil )
	{
		NSString *scheme = [[[req URL] scheme] lowercaseString];
		GVC_ASSERT([scheme isEqual:@"http"] || [scheme isEqual:@"https"], @"Invalid scheme [%@]", scheme );

		[self setAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)]];
	}
	
    return self;
}

- (id)initForURL:(NSURL *)url;
{
    GVC_ASSERT(url != nil, @"No URL");
    return [self initForRequest:[NSURLRequest requestWithURL:url]];
}

- (void)setAcceptableStatusCodes:(NSIndexSet *)newValue
{
	GVC_ASSERT([self isExecuting] == NO, @"Cannot change after operation started" );
	GVC_ASSERT(gvc_IsEmpty(newValue) == NO, @"Acceptable status codes is empty set");
	
	if (newValue != acceptableStatusCodes) 
	{
		[self willChangeValueForKey:@"acceptableStatusCodes"];
		acceptableStatusCodes = nil;
		acceptableStatusCodes = [newValue copy];
		[self didChangeValueForKey:@"acceptableStatusCodes"];
	}
}

- (void)setAcceptableContentTypes:(NSSet *)newValue
{
	if (newValue != acceptableContentTypes) 
	{
		[self willChangeValueForKey:@"acceptableContentTypes"];
		acceptableContentTypes = nil;
		acceptableContentTypes = [newValue copy];
		[self didChangeValueForKey:@"acceptableContentTypes"];
	}
}

- (void)setImageContentTypesOnly
{
    [self setAcceptableContentTypes:gvc_MimeType_Images()];
}

- (BOOL)isStatusCodeAcceptable
{
    GVC_ASSERT([self lastResponse] != nil, @"Final response not set" );
	GVC_ASSERT([self acceptableStatusCodes] != nil, @"No acceptable status codes" );

    NSInteger statusCode = [[self lastResponse] statusCode];
    return (statusCode >= 0) && [[self acceptableStatusCodes] containsIndex: (NSUInteger) statusCode];
}

- (BOOL)isContentTypeAcceptable
{
	GVC_ASSERT([self lastResponse] != nil, @"Final response not set");

    NSString *  contentType = [[self lastResponse] MIMEType];
    return ([self acceptableContentTypes] == nil) || ((contentType != nil) && [[self acceptableContentTypes] containsObject:contentType]);
}

- (NSHTTPURLResponse *)lastResponse
{
    return (NSHTTPURLResponse *)[super lastResponse];
}


@end
