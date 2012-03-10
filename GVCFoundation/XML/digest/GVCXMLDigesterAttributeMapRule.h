//
//  GVCXMLDigesterAttributeMap.h
//  HL7ParseTest
//
//  Created by David Aspinall on 11-02-05.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVCXMLDigesterRule.h"

@class GVCPair;

@interface GVCXMLDigesterAttributeMapRule : GVCXMLDigesterRule

- (id)initWithMap:(NSDictionary *)map;
- (id)initWithKeysAndValues:(NSString *)key, ...;


@property (strong, nonatomic) NSMutableDictionary *attributeMap;
@property (assign) BOOL tryToAssignAll;

- (void)mapAttributesFromDictionary:(NSDictionary *)dict;

- (void)mapAttribute:(NSString *)attributeName toProperty:(NSString *)propertyName;
- (void)setMap:(GVCPair *)pair;

@end
