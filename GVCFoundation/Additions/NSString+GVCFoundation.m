//
//  NSString+GVCFoundation.m
//  GVCFoundation
//
//  Created by David Aspinall on 11-09-28.
//  Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
//

#import "NSString+GVCFoundation.h"

@implementation NSString (GVCFoundation)

#pragma mark - General Class Methods

+ (NSString *)gvc_EmptyString
{
	return @"";
}

+ (NSString *)gvc_stringWithUUID
{
	//create a new UUID
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString * string = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    CFRelease(uuid);
    return string;
}

#pragma mark - General Instance methods


@end
