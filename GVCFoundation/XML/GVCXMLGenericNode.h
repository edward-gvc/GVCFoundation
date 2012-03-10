//
//  DAXMLNode.h
//
//  Created by David Aspinall on 02/02/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCXMLParsingModel.h"


@interface GVCXMLGenericNode : NSObject <GVCXMLContainerNode, GVCXMLNamedNode>

- (id)init;

@property (strong, nonatomic) id <GVCXMLNamespaceDeclaration>defaultNamespace;
@property (strong, nonatomic) NSString *localname;

- (NSString *)qualifiedName;

// XMLNamedContent
- (NSArray *)attributes;
- (void)addAttribute:(id <GVCXMLAttributeContent>)attrb;
- (void)addAttribute:(NSString *)attrb withValue:(NSString *)attval inNamespace:(id <GVCXMLNamespaceDeclaration>)ns;
- (id <GVCXMLAttributeContent>)attributeForName:(NSString *)key;

- (void)addDeclaredNamespace:(id <GVCXMLNamespaceDeclaration>)v;
- (NSArray *)declaredNamespaces;

@end
