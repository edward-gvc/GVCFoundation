/*
 * GVCKeychain.h
 * 
 * Created by David Aspinall on 12-06-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCMacros.h"

@interface GVCKeychain : NSObject

GVC_SINGLETON_HEADER(GVCKeychain)

/** object must be a plist object 
 */
- (BOOL)setSecureObject:(id)object forKey:(NSString *)aKey;
- (id)secureObjectForKey:(NSString *)aKey;

- (BOOL)removeSecureObjectForKey:(NSString *)aKey;

@end
