/*
 * GVCXSDString.h
 * 
 * Created by David Aspinall on 2012-10-29. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCXMLRecursiveNode.h"

/**
 * <#description#>
 */
@interface GVCXSDString : GVCXMLRecursiveNode

/** XMLTextContainer */
@property (strong, nonatomic) NSString *text;

@end
