//
//  GVCXMLDigesterSetPropertyRule.h
//  HL7ParseTest
//
//  Created by David Aspinall on 11-02-05.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVCXMLDigesterRule.h"

@interface GVCXMLDigesterSetPropertyRule : GVCXMLDigesterRule
{
	NSString *propertyName;
	NSString *nodeText;
}

@property (retain, nonatomic) NSString *propertyName;
@property (retain, nonatomic) NSString *nodeText;

- (id)initWithPropertyName:(NSString *)pname;



@end
