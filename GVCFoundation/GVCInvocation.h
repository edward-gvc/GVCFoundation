/*
 * GVCInvocation.h
 * 
 * Created by David Aspinall on 2012-11-30. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

/**
 * This class is used for finding and invoking methods on objects when all you have are class, method and argument names
 */
@interface GVCInvocation : NSObject

- (id)initForTargetClass:(Class)clazz;
- (id)initForTargetClassName:(NSString *)classname;

- (void)findBestSelectorForMethodName:(NSString *)methodName withArguments:(NSUInteger)count;
- (void)findBestSelectorForMethodPattern:(NSString *)methodPattern;

@property (nonatomic, strong) Class targetClass;

@property (nonatomic, strong, readonly) NSMethodSignature *methodSignature;
@property (nonatomic, readonly) SEL selector;

- (NSString *)argumentTypeAtIndex:(NSUInteger)indx;

- (NSInvocation *)invocationForTarget:(id)target arguments:(NSArray *)args;

@end
