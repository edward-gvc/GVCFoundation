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
	if ([self isCancelled] == YES)
	{
		return;
	}
	
	[self operationDidStart];
    GVC_XML_ParserDelegateStatus stat = [[self xmlParser] parse];
	if ( stat != GVC_XML_ParserDelegateStatus_SUCCESS )
	{
		[self operationDidFailWithError:[xmlParser xmlError]];
	}
	else
	{
		[self operationDidFinish];
	}
}

@end
