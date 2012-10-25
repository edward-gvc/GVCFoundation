/*
 * GVCSOAPDocument.h
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCXMLDocument.h"

@class GVCSOAPFault;

/**
 * <#description#>
 */
@interface GVCSOAPDocument : GVCXMLDocument

- (BOOL)isFault;
- (GVCSOAPFault *)faultNode;

@end
