/*
 * NSDictionary+GVCFoundation.m
 * 
 * Created by David Aspinall on 12-03-16. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "NSDictionary+GVCFoundation.h"
#import "NSArray+GVCFoundation.h"


@implementation NSDictionary (GVCFoundation)

- (NSArray *)gvc_sortedKeys
{
	return [[self allKeys] gvc_sortedArray];
}

@end
