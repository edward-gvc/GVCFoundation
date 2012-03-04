/*
 * GVCDirectory.h
 * 
 * Created by David Aspinall on 11-12-06. 
 * Copyright (c) 2011 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCFoundation.h"

@interface GVCDirectory : NSObject

@property (copy, nonatomic) NSString *rootDirectory;

+ (GVCDirectory *)TempDirectory;
+ (GVCDirectory *)CacheDirectory;
+ (GVCDirectory *)DocumentDirectory;
+ (GVCDirectory *)DownloadDirectory;

- (id)initWithRootPath:(NSString *)path;

- (NSString *)fullpathForFile:(NSString *)filename;

- (NSString *)uniqueFilename;
- (NSString *)uniqueFilename:(NSString *)prefix;

- (GVCDirectory *)createSubdirectory:(NSString *)name;

@end
