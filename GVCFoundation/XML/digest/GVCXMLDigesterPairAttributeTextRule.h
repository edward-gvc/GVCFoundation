//
//  GVCXMLDigesterPairAttributeTextRule.h
//  GVCImmunization
//
//  Created by David Aspinall on 11-03-09.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCXMLDigesterSetPropertyRule.h"


@interface GVCXMLDigesterPairAttributeTextRule : GVCXMLDigesterSetPropertyRule

@property (strong, nonatomic) NSString *attributeName;
@property (strong, nonatomic) NSString *pairKey;

- (id) initWithPropertyName:(NSString *)pname andAttributeName:(NSString *)aname;
- (id) initWithAttributeName:(NSString *)pname;

@end
