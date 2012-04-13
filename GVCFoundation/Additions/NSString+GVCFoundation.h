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

/*  Returns an NSString with a hex encoded UUID */
+ (NSString *)gvc_StringWithUUID;

- (NSString *)gvc_md5Hash;

- (NSString *)gvc_StringWithCapitalizedFirstCharacter;
- (NSString *)gvc_TrimWhitespace;

/* files and filenames */
- (NSString *)gvc_stringByAppendingFilename:(NSString *)fname withExtension:(NSString *)ext;

/*  XML supporting methods */
- (NSString *)gvc_XMLAttributeEscapedString;
- (NSString *)gvc_XMLEntityEscapedString:(BOOL)escapeQuotes;

- (NSString *)gvc_XMLPrefixFromQualifiedName;
- (NSString *)gvc_XMLLocalNameFromQualifiedName;

@end
