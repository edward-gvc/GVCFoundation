/*
 * NSFileManager+GVCFoundation.m
 * 
 * Created by David Aspinall on 11-12-06. 
 * Copyright (c) 2011 Global Village Consulting. All rights reserved.
 *
 */

#import "NSFileManager+GVCFoundation.h"
#import "NSData+GVCFoundation.h"

@implementation NSFileManager (GVCFoundation)

- (BOOL)gvc_directoryExists:(NSString *)path
{
	BOOL isDir;
	return ([self fileExistsAtPath:path isDirectory:&isDir] == YES) && (isDir == YES);
}

- (NSString *)gvc_documentsDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

- (NSString *)gvc_cachesDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	if ( [paths count] == 0 )
		return [self gvc_temporaryDirectory];
	return [paths objectAtIndex:0];
}

- (NSString *)gvc_downloadsDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
	if ( [paths count] == 0 )
		return [self gvc_temporaryDirectory];
	return [paths objectAtIndex:0];
}

- (NSString *)gvc_temporaryDirectory
{
	return NSTemporaryDirectory();
}


- (NSString *)gvc_md5Hash:(NSString *)path
{
	NSString *hash = nil;
	NSData *data = [NSData dataWithContentsOfFile:path];
	if (data != nil)
	{	
		hash = [[data gvc_md5Digest] gvc_hexString];
	}
	return hash;
}

- (BOOL)gvc_validateFile:(NSString *)path withMD5Hash:(NSString *)hash 
{
	return [hash isEqualToString:[self gvc_md5Hash:path]];
}

@end
