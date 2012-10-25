//
//  DAXMLNamespace.h
//
//  Created by David Aspinall on 14/09/08.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCXMLParsingModel.h"
#import "GVCPair.h"

@interface GVCXMLNamespace : GVCPair <GVCXMLNamespaceDeclaration>

+ (id <GVCXMLNamespaceDeclaration>)namespaceForPrefix:(NSString *)pfx andURI:(NSString *)u;
- (id)initWithPrefix:(NSString *)name uri:(NSString *)u;

- (NSString *)prefix;
- (NSString *)uri;
- (NSString *)qualifiedPrefix;

- (NSString *)qualifiedNameInNamespace:(NSString *)localname;

@end
