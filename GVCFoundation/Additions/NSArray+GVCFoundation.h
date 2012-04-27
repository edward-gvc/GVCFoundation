/*
 * NSArray+GVCFoundation.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCFoundation.h"

typedef void (^GVCNSArrayEachBlock)(id item);
typedef BOOL (^GVCNSArrayAcceptBlock)(id item);
typedef id (^GVCNSArrayResultBlock)(id item);

@interface NSArray (GVCFoundation)

	// sort an array using KVC
+ (id)gvc_ArrayByOrdering:(NSArray *)array byKey:(NSString *)key ascending:(BOOL)ascending;
+ (id)gvc_ArrayByOrderingSet:(NSSet *)set byKey:(NSString *)key ascending:(BOOL)ascending;

+ (NSArray *)gvc_ArrayByCombining:(NSArray *)array, ...;

- (NSArray *)gvc_sortedStringArray;

- (NSArray *)gvc_ArrayOrderingByKey:(NSString *)key ascending:(BOOL)ascending;

- (NSArray *)gvc_filterArrayForClass:(Class) clazz;
- (NSArray *)gvc_filterArrayForAccept:(GVCNSArrayAcceptBlock)evaluator;
- (NSArray *)gvc_filterArrayForReject:(GVCNSArrayAcceptBlock)evaluator;

- (void)gvc_performOnEach:(GVCNSArrayEachBlock)evaluator;

- (NSArray *)gvc_resultArray:(GVCNSArrayResultBlock)evaluator;

- (NSString *)gvc_componentsJoinedByString:(NSString *)val after:(GVCNSArrayResultBlock)evaluator;

@end


@interface NSMutableArray (GVCFoundation)
- (NSMutableArray *) gvc_removeFirstObject;
- (void)gvc_sortWithOrderingKey:(NSString *)key ascending:(BOOL)ascending;
@end