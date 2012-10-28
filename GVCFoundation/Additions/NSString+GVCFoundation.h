//
//  NSString+GVCFoundation.h
//  GVCFoundation
//
//  Created by David Aspinall on 11-09-28.
//  Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GVCFoundation)

/*  simple class method to return an empty string */
+ (NSString *)gvc_EmptyString;

/*  Returns a NSString with a hex encoded UUID */
+ (NSString *)gvc_StringWithUUID;

/*  Returns a NSString with randomly selected characters */
+ (NSString *)gvc_RandomStringWithLength:(NSUInteger)len;

/**
 * generates a random string
 * @param len - length of the random string to create
 * @param sample - the string to randomly sample characters
 * @returns the random string
 */
+ (NSString *)gvc_RandomStringWithLength:(NSUInteger)len fromSample:(NSString *)sample;

/**
 * Generates an md5 hash of the string by converting it to UTF8 bytes
 * @returns md5 hash
 */
- (NSString *)gvc_md5Hash;

- (NSString *)gvc_StringWithCapitalizedFirstCharacter;
- (NSString *)gvc_TrimWhitespace;
- (NSString *)gvc_TrimWhitespaceAndNewline;

/* components, optionally filters out blank string results */
- (NSArray *)gvc_componentsSeparatedByCharactersInSet:(NSCharacterSet *)val includeEmpty:(BOOL)included;
- (NSArray *)gvc_componentsSeparatedByString:(NSString *)val includeEmpty:(BOOL)included;

/* files and filenames */
- (NSString *)gvc_stringByAppendingFilename:(NSString *)fname withExtension:(NSString *)ext;

/* beginsWith, contains, endWith substring test */
- (BOOL)gvc_beginsWith:(NSString *)substr;
/* beginsWith, contains, endWith substring test */
- (BOOL)gvc_contains:(NSString *)substr;
/* beginsWith, contains, endWith substring test */
- (BOOL)gvc_endsWith:(NSString *)substr;

/** short mime encoding names */
+ (NSString *)gvc_ShortMimeEncodingName:(NSStringEncoding)encode;

/*  XML supporting methods */
- (NSString *)gvc_XMLAttributeEscapedString;
- (NSString *)gvc_XMLEntityEscapedString:(BOOL)escapeQuotes;

- (NSString *)gvc_XMLPrefixFromQualifiedName;
- (NSString *)gvc_XMLLocalNameFromQualifiedName;

@end


@interface NSMutableString (GVCFoundation)
- (void)appendUniCharacter:(unichar)achar;
@end
