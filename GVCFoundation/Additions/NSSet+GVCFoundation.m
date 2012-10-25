/*
 * NSSet+GVCFoundation.m
 * 
 * Created by David Aspinall on 12-05-10. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "NSSet+GVCFoundation.h"
#import "GVCMacros.h"
#import "GVCLogger.h"

@implementation NSSet (GVCFoundation)


- (NSSet *)gvc_resultSet:(GVCCollectionResultBlock)evaluator
{
    GVC_ASSERT(evaluator != nil, @"Evaluator block is required" );
    
    NSMutableSet *results = [[NSMutableSet alloc] initWithCapacity:[self count]];
	[self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		id value = evaluator(obj);
		if (value != nil)
        {
            [results addObject:value];
        }
	}];
    return [results copy];
}

- (NSSet *)gvc_filterForClass:(Class) clazz
{
    GVC_ASSERT(clazz != nil, @"Filter class is required" );
    
    NSMutableSet *results = [[NSMutableSet alloc] initWithCapacity:[self count]];
    for (id each in self) 
    {
        if ( [each isKindOfClass:clazz] == YES )
            [results addObject:each];
    }
    return [results copy];
}

- (NSSet *)gvc_filterForAccept:(GVCCollectionAcceptBlock)evaluator
{
    GVC_ASSERT(evaluator != nil, @"Evaluator block is required" );
    return [self objectsPassingTest:^BOOL(id obj, BOOL *stop) {
		return evaluator(obj);
    }];
}

- (NSSet *)gvc_filterForReject:(GVCCollectionAcceptBlock)evaluator;
{
    GVC_ASSERT(evaluator != nil, @"Evaluator block is required" );
    return [self objectsPassingTest:^BOOL(id obj, BOOL *stop) {
		return evaluator(obj) == NO;
    }];
}

- (NSString *)gvc_componentsJoinedByString:(NSString *)val after:(GVCCollectionResultBlock)evaluator
{
    return [[[self gvc_resultSet:evaluator] allObjects] componentsJoinedByString:val];
}

@end
