//
//  NSString+GVCFoundation.h
//  GVCFoundation
//
//  Created by David Aspinall on 11-09-28.
//  Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCFoundation.h"

@interface NSString (GVCFoundation)

/*  simple class method to return an empty string */
+ (NSString *)gvc_EmptyString;

/*  Returns an NSString with a hex encoded UUID */
+ (NSString *)gvc_stringWithUUID;

@end
