/**
 * GVCKeychain.h
 * 
 * Created by David Aspinall on 12-06-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCMacros.h"

/**
 * The GVKeychain is designed to provide simple access to the iOS and MAC OS encrypted keychain.
 */
@interface GVCKeychain : NSObject

GVC_SINGLETON_HEADER(GVCKeychain)

/**
 * set an object value into the keychain for the specified key.
 * @param object -  must be a plist object (NSString, NSArray, NSDictionary ..)
 * @param key - the key to store the value
 * @returns boolean success
 */
- (BOOL)setSecureObject:(id)object forKey:(NSString *)aKey;

/**
 * retreive a value from the keychain for the specified key
 * @param aKey - the key to obtain the keychain value
 * @returns keychain value object, decoded from plist
 */
- (id)secureObjectForKey:(NSString *)aKey;

/**
 * delete a value from the keychain for the specified key
 * @param aKey - the key to delete the keychain value
 * @returns boolean success
 */
- (BOOL)removeSecureObjectForKey:(NSString *)aKey;

@end
