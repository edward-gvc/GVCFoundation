/*
 * GVCCache.h
 * 
 * Created by David Aspinall on 11-12-05. 
 * Copyright (c) 2011 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCMacros.h"
#import "GVCCacheNode.h"

@class GVCDirectory;

@interface GVCCache : NSObject

GVC_SINGLETON_HEADER(GVCCache)

@property (assign, nonatomic) NSTimeInterval timeoutInterval;
@property (assign, nonatomic) NSUInteger maxDataDiskSize;
@property (assign, nonatomic) NSUInteger maxDataNodeSize;

- (BOOL)cache:(id <GVCCacheNode>)node;

- (id <GVCCacheNode>)cachedNodeFor:(NSString *)key;
- (NSString *)cachedValueFor:(NSString *)key;
- (NSData *)cachedDataFor:(NSString *)key;

- (GVCDirectory *)cacheDataRootDirectory;

@end

@interface GVCKeyValueNode : NSObject <GVCCacheValueNode> 
@property (strong, nonatomic) NSString *cacheKey;
@property (strong, nonatomic) NSString *cacheValue;
@end

@interface GVCDataValueNode : NSObject <GVCCacheDataNode> 
@property (strong, nonatomic) NSString *cacheDataPath;
@property (strong, nonatomic) NSString *cacheKey;
@property (strong, nonatomic) NSData *cacheData;
@end
