/*
 * GVCXMLRecursiveParserBase.h
 * 
 * Created by David Aspinall on 2012-10-27. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

#import "GVCXMLParserDelegate.h"

@class GVCXMLGenerator;
@class GVCStack;

/**
 * <#description#>
 */
@interface GVCXMLRecursiveParserBase : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) GVCXMLRecursiveParserBase *parent;
- (void)reset;

@property (strong, nonatomic) GVCStack *elementStack;
- (NSString *)peekTopElementName;
- (NSString *)elementNamePath:(NSString *)separator;
- (NSString *)fullElementNamePath:(NSString *)separator;

@end
