/*
 * NSFileManager+GVCFoundation.h
 * 
 * Created by David Aspinall on 11-12-06. 
 * Copyright (c) 2011 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCFoundation.h"

@interface NSFileManager (GVCFoundation)

- (NSString *)gvc_cachesDirectory;
- (NSString *)gvc_documentsDirectory;
- (NSString *)gvc_temporaryDirectory;
- (NSString *)gvc_downloadsDirectory;

- (NSString *)gvc_md5Hash:(NSString *)path;
- (BOOL)gvc_validateFile:(NSString *)path withMD5Hash:(NSString *)hash;

- (BOOL)gvc_directoryExists:(NSString *)path;

@end
