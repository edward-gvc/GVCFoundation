/*
 * GVCXMLTextNode.h
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCXMLNode.h"

@class GVCXMLGenerator;

/**
 * <#description#>
 */
@interface GVCXMLTextNode : GVCXMLNode <GVCXMLTextContent>

/** XMLTextContainer */
@property (strong, nonatomic) NSString *text;

- (void)appendText:(NSString *)value;
- (void)appendTextWithFormat:(NSString*)fmt, ...;

- (NSString *)normalizedText;

- (void)generateOutput:(GVCXMLGenerator *)generator;

@end
