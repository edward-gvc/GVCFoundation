/*
 * NSArray+GVCFoundation.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

typedef void (^GVCCollectionForEachBlock)(id item);
typedef BOOL (^GVCCollectionAcceptBlock)(id item);
typedef id (^GVCCollectionResultBlock)(id item);

@interface NSArray (GVCFoundation)

	// sort an array using KVC
+ (id)gvc_ArrayByOrdering:(NSArray *)array byKey:(NSString *)key ascending:(BOOL)ascending;
+ (id)gvc_ArrayByOrderingSet:(NSSet *)set byKey:(NSString *)key ascending:(BOOL)ascending;

+ (NSArray *)gvc_ArrayByCombining:(NSArray *)array, ...;
+ (NSArray *)gvc_ArrayByCombining:(NSArray *)one withArray:(NSArray *)two;

- (NSArray *)gvc_sortedStringArray;

- (NSArray *)gvc_ArrayOrderingByKey:(NSString *)key ascending:(BOOL)ascending;

- (NSArray *)gvc_filterForClass:(Class) clazz;
- (NSArray *)gvc_filterArrayForAccept:(GVCCollectionAcceptBlock)evaluator;
- (NSArray *)gvc_filterArrayForReject:(GVCCollectionAcceptBlock)evaluator;

- (void)gvc_performOnEach:(GVCCollectionForEachBlock)evaluator;

- (NSArray *)gvc_resultArray:(GVCCollectionResultBlock)evaluator;

- (NSString *)gvc_componentsJoinedByString:(NSString *)val after:(GVCCollectionResultBlock)evaluator;

- (BOOL)gvc_isEqualToArrayInAnyOrder:(NSArray *)other;

@end


@interface NSMutableArray (GVCFoundation)
- (NSMutableArray *) gvc_removeFirstObject;
- (void)gvc_sortWithOrderingKey:(NSString *)key ascending:(BOOL)ascending;
@end