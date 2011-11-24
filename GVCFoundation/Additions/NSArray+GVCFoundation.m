/*
 * NSArray+GVCFoundation.m
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import "NSArray+GVCFoundation.h"

@implementation NSArray (GVCFoundation)

	// simple method to sort an array using KVC
+ (id)gvc_ArrayByOrderingSet:(NSSet *)set byKey:(NSString *)key ascending:(BOOL)ascending
{
    NSArray *ret = [NSArray array];
	
	if ( set != nil )
	{
		NSMutableArray *working = [NSMutableArray arrayWithArray:[set allObjects]];
		if ( gvc_IsEmpty(key) == NO )
		{
			NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
			[working sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
		}
		
		ret = [NSArray arrayWithArray:working];
	}
    return ret;
}

@end
