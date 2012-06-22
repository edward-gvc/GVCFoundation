/*
 * GVCKeychain.m
 * 
 * Created by David Aspinall on 12-06-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCKeychain.h"
#import "GVCFunctions.h"
#import "GVCLogger.h"

#import <Security/Security.h>

@interface GVCKeychain ()

@end

@implementation GVCKeychain

GVC_SINGLETON_CLASS(GVCKeychain)

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
	}
	
    return self;
}

- (BOOL)setSecureObject:(id)object forKey:(NSString *)aKey
{
    GVC_ASSERT_NOT_NIL(aKey);
    GVC_ASSERT_NOT_NIL(object);

    BOOL success = NO;
    NSString *errMessage = nil;
    NSData * data = [NSPropertyListSerialization dataFromPropertyList:object format:NSPropertyListBinaryFormat_v1_0 errorDescription:&errMessage];
    if (data != nil) 
    {
#if TARGET_OS_IPHONE
        NSMutableDictionary* queryDictionary = [[NSMutableDictionary alloc] init];
        [queryDictionary setObject:aKey forKey:(__bridge id)kSecAttrAccount];
        [queryDictionary setObject:@"service" forKey:(__bridge id)kSecAttrService];
        [queryDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        
        NSMutableDictionary* attributes = [[NSMutableDictionary alloc] init];
        [attributes setObject:data forKey:(__bridge id)kSecValueData];
        OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)queryDictionary, (__bridge CFDictionaryRef)attributes);
        if (status == errSecItemNotFound) 
        {
            [attributes addEntriesFromDictionary:queryDictionary];
            status = SecItemAdd((__bridge CFDictionaryRef)attributes, NULL);
        }
#else
        const char* name = [aKey UTF8String];
        OSStatus status = SecKeychainAddGenericPassword(NULL, strlen(name), name, strlen(name), name, data.length, data.bytes, NULL);
#endif
        if (status == noErr) 
        {
            success = YES;
        }
        else
        {
            GVCLogError(@"Failed adding item for \"%@\" to Keychain (%i)", aKey, status);
        }
    }
    else
    {
        GVCLogError( @"plist serialization failed '' for object %@", errMessage, object);
    }

    return success;
}

- (id)secureObjectForKey:(NSString *)aKey;
{
    GVC_ASSERT_NOT_NIL(aKey);
    id object = nil;
    
#if TARGET_OS_IPHONE
    NSString *errMessage = nil;
	NSMutableDictionary *queryDictionary = [NSMutableDictionary dictionary];

	[queryDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[queryDictionary setObject:@"service" forKey:(__bridge id)kSecAttrService];
	[queryDictionary setObject:aKey forKey:(__bridge id)kSecAttrAccount];
	[queryDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
	
	CFTypeRef data = nil;
	OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)queryDictionary, &data);

    if (status == noErr) 
    {
        object = [NSPropertyListSerialization propertyListFromData:(__bridge NSData *)data mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:&errMessage];
    }
#else
    UInt32 length = 0;
    void* bytes = 0;
    const char* name = [aKey UTF8String];
    OSStatus status = SecKeychainFindGenericPassword(NULL, strlen(name), name, strlen(name), name, &length, &bytes, NULL);
    if (status == noErr)
    {
        data = [[NSData alloc] initWithBytes:bytes length:length];
        SecKeychainItemFreeContent(NULL, bytes);
        object = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:&errMessage];
    }
#endif
    return object;
}

- (BOOL)removeSecureObjectForKey:(NSString *)aKey;
{
    GVC_ASSERT_NOT_NIL(aKey);

#if TARGET_OS_IPHONE
    NSMutableDictionary* queryDictionary = [[NSMutableDictionary alloc] init];
    [queryDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[queryDictionary setObject:@"service" forKey:(__bridge id)kSecAttrService];
    [queryDictionary setObject:aKey forKey:(__bridge id)kSecAttrAccount];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)queryDictionary);
#else
    SecKeychainItemRef item = NULL;
    const char* name = [aKey UTF8String];
    OSStatus status = SecKeychainFindGenericPassword(NULL, strlen(name), name, strlen(name), name, NULL, NULL, &item);
    if (status == noErr) 
    {
        status = SecKeychainItemDelete(item);
    }
#endif
    return ((status == noErr) || (status == errSecItemNotFound));
}

@end
