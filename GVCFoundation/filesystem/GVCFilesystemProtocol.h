/*
 * GVCFilesystemProtocol.h
 * 
 * Created by David Aspinall on 2012-11-17. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

// forward declaration
@protocol GVCFileProtocol;
@protocol GVCDirectoryProtocol;

/**
 * A protocol for various filesystem features so local and network operations can follow a common interface
 */


@protocol GVCFilesystemItemProtocol <NSObject>

- (NSString *)name;
- (NSString *)fullpath;
- (id <GVCDirectoryProtocol>)directory;

@end

@protocol GVCFileProtocol <NSObject, GVCFilesystemItemProtocol>

@end


@protocol GVCDirectoryProtocol <NSObject, GVCFilesystemItemProtocol>

@end
