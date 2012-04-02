/*
 * NSArray+GVCFoundation.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCFoundation.h"

@interface NSArray (GVCFoundation)

	// sort an array using KVC
+ (id)gvc_ArrayByOrdering:(NSArray *)array byKey:(NSString *)key ascending:(BOOL)ascending;
+ (id)gvc_ArrayByOrderingSet:(NSSet *)set byKey:(NSString *)key ascending:(BOOL)ascending;

+ (NSArray *)gvc_ArrayByCombining:(NSArray *)array, ...;

- (NSArray *)gvc_sortedArray;

- (NSArray *)gvc_ArrayOrderingByKey:(NSString *)key ascending:(BOOL)ascending;

@end
