/*
 * NSDictionary+GVCFoundation.h
 * 
 * Created by David Aspinall on 12-03-16. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@interface NSDictionary (GVCFoundation)

/** return the dictonary keys in sorted order */
- (NSArray *)gvc_sortedKeys;

@end
