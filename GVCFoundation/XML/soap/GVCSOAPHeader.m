/*
 * GVCSOAPHeader.m
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCSOAPHeader.h"
#import "GVCXMLNamespace.h"

@interface GVCSOAPHeader ()

@end

@implementation GVCSOAPHeader

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
		[self setLocalname:@"Header"];
		[self setDefaultNamespace:[GVCXMLNamespace namespaceForPrefix:@"soapenv" andURI:@"http://schemas.xmlsoap.org/soap/envelope/"]];
	}
	
    return self;
}

@end
