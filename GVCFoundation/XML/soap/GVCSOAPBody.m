/*
 * GVCSOAPBody.m
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCSOAPBody.h"
#import "GVCXMLNamespace.h"


@interface GVCSOAPBody ()

@end

@implementation GVCSOAPBody

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
		[self setLocalname:@"Body"];
		[self setDefaultNamespace:[GVCXMLNamespace namespaceForPrefix:@"soapenv" andURI:@"http://schemas.xmlsoap.org/soap/envelope/"]];
	}
	
    return self;
}

@end
