//
//  GVCXMLDigesterElementNamePropertyRule.h
//  GVCOpenXML
//
//  Created by David Aspinall on 11-03-11.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVCXMLDigesterRule.h"

@interface GVCXMLDigesterElementNamePropertyRule : GVCXMLDigesterRule 

@property (strong, nonatomic) NSString *propertyName;

- (id)initWithPropertyName:(NSString *)pname;

@end
