//
//  NSString+GVCFoundation.m
//  GVCFoundation
//
//  Created by David Aspinall on 11-09-28.
//  Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
//

#import "NSString+GVCFoundation.h"
#import "NSData+GVCFoundation.h"

@implementation NSString (GVCFoundation)

#pragma mark - General Class Methods

+ (NSString *)gvc_EmptyString
{
	return @"";
}

+ (NSString *)gvc_StringWithUUID
{
	//create a new UUID
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString * string = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    CFRelease(uuid);
    return string;
}

#pragma mark - General Instance methods

- (NSString *)gvc_md5
{
    NSString *hash = nil;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (data != nil)
    {	
        hash = [[data gvc_md5Digest] gvc_hexString];
    }
    return hash;
}

@end
