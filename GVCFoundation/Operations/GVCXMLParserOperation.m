/*
 * GVCXMLDigestOperation.m
 * 
 * Created by David Aspinall on 12-03-27. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCXMLParserOperation.h"

#import "GVCXMLParserDelegate.h"

@implementation GVCXMLParserOperation

@synthesize xmlParser;

- (id)initForParser:(GVCXMLParserDelegate *)dgst
{
	self = [super init];
	if ( self != nil )
	{
        [self setXmlParser:dgst];
	}
	
    return self;
}

- (void)main
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_NIL([self xmlParser]);
					)
	
	// implementation
	if ([self isCancelled] == YES)
	{
		return;
	}
	
	[self operationDidStart];
    GVCXMLParserDelegate_Status stat = [[self xmlParser] parse];
	if ( stat != GVCXMLParserDelegate_Status_SUCCESS )
	{
		[self operationDidFailWithError:[xmlParser xmlError]];
	}
	else
	{
		[self operationDidFinish];
	}

	GVC_DBC_ENSURE()
}

@end
