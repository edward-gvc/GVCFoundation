/*
 * NSError+GVCFoundation.h
 * 
 * Created by David Aspinall on 12-03-18. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@interface NSError (GVCFoundation)

+ (NSError *)gvc_ErrorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescription:(NSString *)descript;

@end
