/*
 * GVCConfigProperty.h
 * 
 * Created by David Aspinall on 12-05-17. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCConfigObject.h"

@interface GVCConfigProperty : GVCConfigObject

@property (strong, nonatomic) NSString *action;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *value;

@end

