/*
 * GVCConfigResource.h
 * 
 * Created by David Aspinall on 12-05-17. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCConfigObject.h"

@interface GVCConfigResource : GVCConfigObject

@property (strong, nonatomic) NSString *action;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *tag;
@property (strong, nonatomic) NSString *md5;
@property (strong, nonatomic) NSString *status;

@property (strong, nonatomic) NSString *path;

@end
