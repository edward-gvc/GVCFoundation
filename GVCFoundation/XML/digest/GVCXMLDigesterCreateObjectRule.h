//
//  GVCXMLDigestCreateObjectRule.h
//  HL7ParseTest
//
//  Created by David Aspinall on 11-02-04.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVCXMLDigesterRule.h"

@interface GVCXMLDigesterCreateObjectRule : GVCXMLDigesterRule


- (id)initForClassname:(NSString *)clazz orFromAttribute:(NSString *)attrib;
- (id)initForClassname:(NSString *)clazz;
- (id)initForClassnameFromAttribute:(NSString *)attrib;

@property (strong, nonatomic) NSString *classname;
@property (strong, nonatomic) NSString *classnameFromAttribute;

@end
