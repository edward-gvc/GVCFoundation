/*
 * GVCConfigPackage.h
 * 
 * Created by David Aspinall on 12-05-17. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCConfigObject.h"

@class GVCConfigResource;
@class GVCConfigProperty;

@interface GVCConfigPackage : GVCConfigObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *status;

- (NSArray *)allProperties;
- (void)addProperty:(GVCConfigProperty *)prop;

- (void)addResource:(GVCConfigResource *)resource;
- (GVCConfigResource *)resourceForName:(NSString *)name;
- (NSArray *)resourcesForTag:(NSString *)tag;

@end


@interface GVCConfigSharedPackage : GVCConfigPackage

@end
