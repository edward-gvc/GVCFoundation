//
//  GVCXMLDigesterSetChildRule.h
//  HL7ParseTest
//
//  Created by David Aspinall on 11-02-05.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVCXMLDigesterRule.h"

@interface GVCXMLDigesterSetChildRule : GVCXMLDigesterRule
{
	NSString *propertyName;
}

@property (retain, nonatomic) NSString *propertyName;

- (id)initWithPropertyName:(NSString *)pname;


@end
