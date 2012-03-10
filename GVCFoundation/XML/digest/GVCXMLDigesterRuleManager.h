//
//  GVCXMLDigesterRuleManager.h
//  HL7ParseTest
//
//  Created by David Aspinall on 11-02-04.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCXMLParsingModel.h"

@class GVCXMLDigester;
@class GVCXMLDigesterRule;
@class GVCXMLDigesterRuleset;

@interface GVCXMLDigesterRuleManager : NSObject 

- (id)initForDigester:(GVCXMLDigester *)dgst;

@property (weak, readonly, nonatomic) GVCXMLDigester *digester;
@property (strong, nonatomic) NSMutableDictionary *ruleset;

- (void)addRule:(GVCXMLDigesterRule *)rule forPattern:(NSString *)pattern;
- (void)addRuleList:(NSArray *)ruleList forPattern:(NSString *)pattern;

- (NSArray *)match:(NSString *)node_path;
- (NSArray *)match:(NSString *)node_path inNamespace:(NSString *)namesp;

@end


