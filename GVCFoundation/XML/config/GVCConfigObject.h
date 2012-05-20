/*
 * GVCConfigObject.h
 * 
 * Created by David Aspinall on 12-05-17. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@class GVCXMLGenerator;

@interface GVCConfigObject : NSObject

- (void)writeConfiguration:(GVCXMLGenerator *)outputGenerator;

@end
