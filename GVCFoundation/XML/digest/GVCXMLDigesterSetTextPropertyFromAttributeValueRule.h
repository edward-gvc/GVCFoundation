//
//  GVCXMLDigesterSetTextPropertyFromAttributeValueRule.h
//  GVCImmunization
//
//  Created by David Aspinall on 11-02-07.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVCXMLDigesterSetPropertyRule.h"

@interface GVCXMLDigesterSetTextPropertyFromAttributeValueRule : GVCXMLDigesterSetPropertyRule
{
	NSString *attributeName;
}

@property (retain, nonatomic) NSString *attributeName;

- (id) initWithAttributeName:(NSString *)pname;

@end
