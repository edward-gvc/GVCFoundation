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

@property (strong, nonatomic) NSString *propertyName;
@property (strong, nonatomic) NSString *nodeText;

- (id)initWithPropertyName:(NSString *)pname;

@end

@interface GVCXMLDigesterSetCDATARule : GVCXMLDigesterSetPropertyRule

@property (strong, nonatomic) NSData *nodeCDATA;

- (id)initWithPropertyName:(NSString *)pname;

@end
