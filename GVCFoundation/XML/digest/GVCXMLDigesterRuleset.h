//
//  GVCXMLDigesterRuleset.h
//  HL7ParseTest
//
//  Created by David Aspinall on 11-02-06.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GVCXMLDigesterRule;

@interface GVCXMLDigesterRuleset : NSObject

@property (strong, nonatomic) NSString *nodeName;
@property (strong, nonatomic) NSString *pattern;
@property (strong, nonatomic) NSMutableArray *rules;

- (void)addRule:(GVCXMLDigesterRule *)aRule;

@end
