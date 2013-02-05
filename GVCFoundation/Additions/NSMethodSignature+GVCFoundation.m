/*
 * NSMethodSignature+GVCFoundation.m
 * 
 * Created by David Aspinall on 2013-02-02. 
 * Copyright (c) 2013 Global Village Consulting. All rights reserved.
 *
 */

#import "NSMethodSignature+GVCFoundation.h"

#import <objc/runtime.h>

@implementation NSMethodSignature (GVCFoundation)

- (NSString *)description
{
    /* Don't use -[NSString stringWithFormat:] method because it can cause infinite recursion. */
    char buffer[512];
	
    sprintf (buffer, "<%s %p types=%s>", (char*)object_getClassName(self), self, [self getArgumentTypeAtIndex:0]);
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}


@end
