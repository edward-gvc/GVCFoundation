/*
 * NSData+GVCFoundation.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCFoundation.h"

@interface NSData (GVCFoundation)

	//overide the default implementation
- (NSString *)description;

	// startOffset may be negative, indicating offset from end of data
- (NSString *)gvc_descriptionFromOffset:(NSInteger)startOffset;
- (NSString *)gvc_descriptionFromOffset:(NSInteger)startOffset limitingToByteCount:(NSUInteger)maxBytes;

- (NSData *)gvc_md5Digest;
- (NSData *)gvc_sha1Digest;
- (NSString *)gvc_hexString;

+ (NSData *)gvc_Base64Decoded:(NSString *)encoded;

- (NSString *)gvc_base64Encoded;
- (NSData *)gvc_base64Decoded;

@end


@interface NSMutableData (GVCFoundation)

- (void)gvc_appendUTF8String:(NSString *) string;
- (void)gvc_appendUTF8Format:(NSString *) format, ...;

@end
