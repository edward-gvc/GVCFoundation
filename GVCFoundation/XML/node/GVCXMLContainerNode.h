/*
 * GVCXMLContainerNode.h
 * 
 * Created by David Aspinall on 12-03-13. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCXMLNode.h"

@class GVCXMLGenerator;

@interface GVCXMLContainerNode : GVCXMLNode <GVCXMLContainerNode>

	// GVCXMLContainerNode
- (NSArray *)children;
- (id <GVCXMLContent>)addContent:(id <GVCXMLContent>) child;

- (void)generateOutput:(GVCXMLGenerator *)generator;

@end
