/*
 * GVCSOAPEnvelope.m
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCSOAPEnvelope.h"
#import "GVCXMLNamespace.h"

@interface GVCSOAPEnvelope ()

@end

@implementation GVCSOAPEnvelope

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
		[self setLocalname:@"Envelope"];
		[self setDefaultNamespace:[GVCXMLNamespace namespaceForPrefix:@"soapenv" andURI:@"http://schemas.xmlsoap.org/soap/envelope/"]];
	}
	
    return self;
}

@end
