//
//  GVCXMLDigestSetChildForAttributeKeyRule.h
//  GVCImmunization
//
//  Created by David Aspinall on 11-03-09.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVCXMLDigesterSetChildRule.h"

@interface GVCXMLDigestSetChildForAttributeKeyRule : GVCXMLDigesterSetChildRule
{
	NSString *attributeName;
}

@property (strong, nonatomic) NSString *attributeName;

- (id) initWithAttributeName:(NSString *)pname;

@end
