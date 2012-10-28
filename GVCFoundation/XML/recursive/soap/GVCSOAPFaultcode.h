/*
 * GVCSOAPFaultcode.h
 * 
 * Created by David Aspinall on 2012-10-27. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCXMLParsingModel.h"
#import "GVCXMLRecursiveNode.h"
#import "GVCMacros.h"

GVC_DEFINE_EXTERN_STR(GVCSOAPFaultcode_elementname);

/**
 * <#description#>
 */
@interface GVCSOAPFaultcode : GVCXMLRecursiveNode <GVCXMLTextContent>

/** XMLTextContainer */
@property (strong, nonatomic) NSString *text;

- (void)appendText:(NSString *)value;
- (void)appendTextWithFormat:(NSString*)fmt, ...;

- (NSString *)normalizedText;

@end
