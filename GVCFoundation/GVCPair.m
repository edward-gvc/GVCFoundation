//
//  DAPair.m
//
//  Created by David Aspinall on 05/08/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCPair.h"
#import "GVCMacros.h"

@interface GVCPair ()
@property (readwrite, nonatomic, strong) id left;
@property (readwrite, nonatomic, strong) id right;
@end

@implementation GVCPair

@synthesize left;
@synthesize right;


- (id)initWith:(id)obj and:(id)obj2;
{
	GVC_ASSERT(obj != nil, @"Pair Objects cannot be nil" );
	GVC_ASSERT(obj2 != nil, @"Pair Objects cannot be nil" );
	
	self = [super init];
	if (self != nil)
	{
		[self setLeft:obj];
		[self setRight:obj2];
	}
	return self;
}

/** Implementation */

- (BOOL)isEqual:(id)object
{
	if (self == object) 
	{
		return YES;
	}
	
	if ((object == nil) || ([object isKindOfClass:[self class]] == NO))
	{
        return NO;
	}
		
	return [self isEqualToPair:(GVCPair *)object];
}

- (BOOL)isEqualToPair:(GVCPair *)object
{
	GVC_ASSERT(object != nil, @"cannot compare to nil object");

	if (self == object) 
	{
		return YES;
	}

	return ([[self left] isEqual:[object left]] && [[self right] isEqual:[object right]]);
}

- (NSUInteger)hash
{
	NSUInteger hash = 7;
	hash = 31 * hash + [left hash];
	hash = 31 * hash + [right hash];

	return hash;
}

@end
