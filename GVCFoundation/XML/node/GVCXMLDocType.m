//
//  DAXMLDocType.m
//
//  Created by David Aspinall on 14/09/08.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCXMLDocType.h"
#import "GVCXMLGenerator.h"

#import "GVCMacros.h"

@implementation GVCXMLDocType

@synthesize elementName;
@synthesize publicID;
@synthesize systemID;
@synthesize internalSubset;

+ (id)docTypeWithName:(NSString *)name publicId:(NSString *)public systemId:(NSString *)systemId
{
	return [[GVCXMLDocType alloc] initWithName:name publicId:public systemId:systemId];
}

- initWithName:(NSString *)name publicId:(NSString *)public systemId:(NSString *)systemId
{
	self = [super init];
	if ( self ) 
	{
		[self setElementName:name publicID:public systemID:systemId forInternalSubset:nil];
	}
	return self;
}

- (void)setElementName:(NSString *)name publicID:(NSString *)public systemID:(NSString *)systemId forInternalSubset:(NSString *)internal
{
	[self setElementName:name];
	[self setPublicID:public];
	[self setSystemID:systemId];
	[self setInternalSubset:internal];
}

-(GVC_XML_ContentType)xmlType
{
	return GVC_XML_ContentType_SIMPLE;
}

- (void)generateOutput:(GVCXMLGenerator *)generator;
{
	if ( generator != nil )
	{
		[generator writeDoctype:[self elementName] identifiers:[self publicID] system:[self systemID] internalSubset:[self internalSubset]];
	}
}

@end
