/*
 * NSArray+GVCFoundation.m
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import "NSArray+GVCFoundation.h"
#import "GVCMacros.h"
#import "GVCFunctions.h"

@implementation NSArray (GVCFoundation)

	// simple method to sort an array using KVC
+ (id)gvc_ArrayByOrdering:(NSArray *)array byKey:(NSString *)key ascending:(BOOL)ascending
{
    NSArray *ret = array;
	
	if ((gvc_IsEmpty(array) == NO) && (gvc_IsEmpty(key) == NO))
	{
		NSMutableArray *working = [NSMutableArray arrayWithArray:array];
		NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
		[working sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
		
		ret = [NSArray arrayWithArray:working];
	}
    return ret;
}

// simple method to sort an array using KVC
+ (id)gvc_ArrayByOrderingSet:(NSSet *)set byKey:(NSString *)key ascending:(BOOL)ascending
{
    NSArray *ret = [NSArray array];
	if ( set != nil )
	{
		ret = [self gvc_ArrayByOrdering:[set allObjects] byKey:key ascending:ascending];
	}
    return ret;
}


- (NSArray *)gvc_sortedArray
{
    return [self sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray *)gvc_ArrayOrderingByKey:(NSString *)key ascending:(BOOL)ascending
{
	return [NSArray gvc_ArrayByOrdering:self byKey:key ascending:ascending];
}


@end
