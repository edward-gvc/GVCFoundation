//
//  GVCFunctions.h
//  GVCFoundation
//
//  Created by David Aspinall on 11-09-30.
//  Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
//

#ifndef _GVCFunctions_
#define _GVCFunctions_

#import <Foundation/NSString.h>
#import <Foundation/NSBundle.h>
#import <Foundation/NSValue.h>
#import <Foundation/NSDictionary.h>

#import "GVCMacros.h"


GVC_EXTERN void gcv_SwizzleClassMethod(Class c, SEL orig, SEL new);
GVC_EXTERN void gcv_SwizzleInstanceMethod(Class c, SEL orig, SEL new);

#pragma mark - Collection Functions
GVC_EXTERN BOOL gcv_IsEqualCollection(id collectionA, id collectionB);


#pragma mark - Empty or Nil test 
	// Credit: http://www.wilshipley.com/blog/2005/10/pimp-my-code-interlude-free-code.html
static inline BOOL gvc_IsEmpty(id thing) 
{
    return thing == nil	
        || ([thing isEqual:[NSNull null]]) 
		|| ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0)
		|| ([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0);
}

#pragma mark - Localized Resource Functions

/* These functions are roughly equivalent to the NSLocalizedString, with the addition of creating a usable strings file in /tmp/ with any missing keys.  Useful in development to generating a strings list.
 */
GVC_EXTERN NSString *gvc_LocalizedString(NSString *key);
GVC_EXTERN NSString *gvc_LocalizedStringWithDefaultValue(NSString *key, NSString *defValue);

/* this function assumes the fmt is a key that will return a localized format that will then be applied against the VA_ARGS.  This is useful for an english format of "%@ is my name" and a french format of "Nom %@" and passing in an argument of "David" 
 */
GVC_EXTERN NSString *gvc_LocalizedFormat(NSString *fmt, ...);


#if DEBUG == 1
    #define GVC_LocalizedString(K, V)		gvc_LocalizedStringWithDefaultValue(K, V)
    #define GVC_LocalizedClassString(K, V)  gvc_LocalizedStringWithDefaultValue(GVC_CLS_DOMAIN_KEY(K), V)
    #define GVC_LocalizedFormat(K, ...)     gvc_LocalizedFormat(K, ##__VA_ARGS__)
#else
    #define GVC_LocalizedString(K, V)       NSLocalizedString(K, V)
    #define GVC_LocalizedFormat(K, ...)     [NSString stringWithFormat:NSLocalizedString(K), ##__VA_ARGS__]
#endif

#define GVC_UNKNOWN_LABEL		GVC_LocalizedString(@"Label/Unknown",   @"Unknown")
#define GVC_SAVE_LABEL			GVC_LocalizedString(@"Label/Save",      @"Save")
#define GVC_CANCEL_LABEL		GVC_LocalizedString(@"Label/Cancel",    @"Cancel")
#define GVC_LOGIN_LABEL			GVC_LocalizedString(@"Label/Login",     @"Login")
#define GVC_LOGOUT_LABEL		GVC_LocalizedString(@"Label/Logout",    @"Logout")


/* XML functions to split prefix and local names from qualified names */
GVC_EXTERN NSString *gvc_XMLPrefixFromQualifiedName(NSString *qname);
GVC_EXTERN NSString *gvc_XMLLocalNameFromQualifiedName(NSString *qname);

GVC_EXTERN void gvc_UncaughtException(NSException *exception);

#endif // _GVCFunctions_
