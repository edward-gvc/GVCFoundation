/*
 * NSError+GVCFoundation.m
 * 
 * Created by David Aspinall on 12-03-18. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "NSError+GVCFoundation.h"

@implementation NSError (GVCFoundation)

+ (NSError *)gvc_ErrorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescription:(NSString *)descript
{
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:descript, NSLocalizedDescriptionKey, nil];
	return [NSError errorWithDomain:domain code:code userInfo:userInfo];
}

@end
