//
//  GVCStack.h
//
//  Created by David Aspinall on 10-02-03.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVCStack : NSObject

- (id)init;
- (id)initWithObject:(id)anObject;

- (void)pushObject:(id)anObject;
- (id)popObject;
- (void)pushObjects:(id)object,...;

- (id)peekObject;
- (id)peekObjectAtIndex:(NSUInteger)idx;

- (void)clear;

- (id)topObject;
- (NSArray *)topObjects:(int)count;
- (NSUInteger)count;
- (NSArray *)allObjects;
- (BOOL)isEmpty;

@end
