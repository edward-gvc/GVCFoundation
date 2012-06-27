/*
 * NSSet+GVCFoundation.h
 * 
 * Created by David Aspinall on 12-05-10. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

#import "NSArray+GVCFoundation.h"

@interface NSSet (GVCFoundation)

- (NSSet *)gvc_resultSet:(GVCCollectionResultBlock)evaluator;
- (NSSet *)gvc_filterForClass:(Class) clazz;
- (NSSet *)gvc_filterForAccept:(GVCCollectionAcceptBlock)evaluator;
- (NSSet *)gvc_filterForReject:(GVCCollectionAcceptBlock)evaluator;

- (NSString *)gvc_componentsJoinedByString:(NSString *)val after:(GVCCollectionResultBlock)evaluator;

@end
