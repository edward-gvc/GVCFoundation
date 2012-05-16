/*
 * NSFileManager+GVCFoundation.h
 * 
 * Created by David Aspinall on 11-12-06. 
 * Copyright (c) 2011 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@interface NSFileManager (GVCFoundation)

- (NSString *)gvc_cachesDirectoryPath;
- (NSString *)gvc_documentsDirectoryPath;
- (NSString *)gvc_temporaryDirectoryPath;
- (NSString *)gvc_downloadsDirectoryPath;

- (NSURL *)gvc_cachesDirectoryURL;
- (NSURL *)gvc_documentsDirectoryURL;
- (NSURL *)gvc_temporaryDirectoryURL;
- (NSURL *)gvc_downloadsDirectoryURL;

- (NSString *)gvc_md5Hash:(NSString *)path;
- (BOOL)gvc_validateFile:(NSString *)path withMD5Hash:(NSString *)hash;

- (BOOL)gvc_directoryExists:(NSString *)path;

- (NSArray *)gvc_filePathsWithExtension:(NSString *)extension inDirectory:(NSString *)directoryPath;
- (NSArray *)gvc_filePathsWithExtensions:(NSArray *)extensions inDirectory:(NSString *)directoryPath;

@end
