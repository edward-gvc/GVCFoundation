/*
 * NSURLRequest+GVCFoundation.m
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "NSURLRequest+GVCFoundation.h"
#import "GVCFunctions.h"
#import "GVCMacros.h"

@implementation NSURLRequest (GVCFoundation)

- (NSString *)gvc_debugDescription
{
	NSMutableString *buffer = [[NSMutableString alloc] init];
	[buffer appendFormat:@"<%@> %@ %@", GVC_CLASSNAME(self), [self HTTPMethod], [self URL]];
	NSDictionary *httpHeaders = [self allHTTPHeaderFields];
	for ( NSString *key in httpHeaders)
	{
		[buffer appendFormat:@"\n\t%@ = '%@'", key, [httpHeaders objectForKey:key]];
	}
	if ( [self HTTPBodyStream] != nil )
	{
		[buffer appendString:@"\nBody is stream"];
	}
	else if ( [self HTTPBody] != nil )
	{
		[buffer appendFormat:@"\n%@", [[self HTTPBody] description]];
	}
	else
	{
		[buffer appendString:@"\nNo Body"];
	}
	
	return buffer;
}

@end
