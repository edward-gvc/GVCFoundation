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

/**
 * Generates a md5 hash for a file
 * @param path - full path to the file
 * @returns md5 hash value as hex string
 */
- (NSString *)gvc_md5Hash:(NSString *)path;

/**
 * generates md5 hash for the file and compares it to the provided value
 * @param path - full path to the file
 * @param hash - hash used for comparison
 * @returns boolean comparison result
 */
- (BOOL)gvc_validateFile:(NSString *)path withMD5Hash:(NSString *)hash;

/**
 * test for a valid directory at the specified path
 * @param path - full path to the file
 * @returns boolean true if the directory exists
 */
- (BOOL)gvc_directoryExists:(NSString *)path;

/**
 * Obtains a list of files in the specified directory with a matching file extension
 * @param extension - the file extension to search
 * @param directoryPath - full path to the directory
 * @returns array of matching files
 */
- (NSArray *)gvc_filePathsWithExtension:(NSString *)extension inDirectory:(NSString *)directoryPath;

/**
 * Obtains a list of files in the specified directory with a matching file extension(s)
 * @param extensions - an array of extensions to search
 * @param directoryPath - full path to the directory
 * @returns array of matching files
 */
- (NSArray *)gvc_filePathsWithExtensions:(NSArray *)extensions inDirectory:(NSString *)directoryPath;

@end
