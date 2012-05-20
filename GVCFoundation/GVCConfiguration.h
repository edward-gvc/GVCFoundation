/*
 * GVCConfiguration.h
 * 
 * Created by David Aspinall on 12-05-12. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCMacros.h"

@class GVCXMLDigester;

@interface GVCConfiguration : NSObject

GVC_SINGLETON_HEADER(GVCConfiguration)

@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) NSDate *lastModifiedDate;

- (GVCXMLDigester *)digester;
- (void)reloadConfiguration;
- (BOOL)hasCompletedLoad;

- (NSString *)configurationPropertyForKey:(NSString *)key;
- (NSString *)configurationResourcePathForKey:(NSString *)key;
- (NSArray *)configurationResourceKeysForGroup:(NSString *)key;

@end

