/*
 * GVCConfigDocument.h
 * 
 * Created by David Aspinall on 12-05-17. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCConfigObject.h"

@class GVCConfigPackage;
@class GVCConfigSharedPackage;

@interface GVCConfigDocument : GVCConfigObject

@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *md5;

@property (strong, nonatomic) GVCConfigSharedPackage *sharedPackage;

- (NSArray *)packageNames;
- (NSArray *)allPackages;
- (void)addPackage:(GVCConfigPackage *)package;
- (GVCConfigPackage *)packageForName:(NSString *)name;
- (void)removePackageForName:(NSString *)pkg;

@end
