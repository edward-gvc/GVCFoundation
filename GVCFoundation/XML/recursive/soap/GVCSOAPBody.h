/*
 * GVCSOAPBody.h
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCXMLRecursiveNode.h"
#import "GVCMacros.h"

GVC_DEFINE_EXTERN_STR(GVCSOAPBody_elementname);

/**
 * <#description#>
 */
@interface GVCSOAPBody : GVCXMLRecursiveNode

- (NSArray *)contentArray;
- (id <GVCXMLContent>)addContent:(id <GVCXMLContent>) child;

@end
