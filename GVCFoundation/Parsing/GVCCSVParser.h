//
//  GVCCSVParser.h
//
//  Created by David Aspinall on 10-12-06.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCParser.h"

@interface GVCCSVParser : GVCParser 

- (id)initWithDelegate:(id <GVCParserDelegate>)del separator:(NSString *)aSep fieldNames:(NSArray *)names firstLineHeaders:(BOOL)isFirstLineHeaders;

@end
