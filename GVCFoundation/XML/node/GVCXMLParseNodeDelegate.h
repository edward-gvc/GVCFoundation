//
//  GVCXMLParseNodeDelegate.h
//
//  Created by David Aspinall on 10-12-21.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVCXMLParserDelegate.h"

@interface GVCXMLParseNodeDelegate : GVCXMLParserDelegate

- (id)init;

@property (strong, nonatomic) id <GVCXMLDocumentNode> document;

/**
 * node creation methods, these methods are called by internal parse events to give subclasses an opportunity to customize the container documents
 */

- (id <GVCXMLDocumentNode>)documentInstance;
- (id <GVCXMLDocumentTypeDeclaration>)documentTypeInstance:(NSString *)name publicId:(NSString *)pubId systemId:(NSString *)sysId;

- (id <GVCXMLNamespaceDeclaration>)namespaceInstance:(NSString *)pfx URI:(NSString *)u;

- (id <GVCXMLAttributeContent>)attributeInstance:(NSString *)name value:(NSString *)value inNamespace:(id <GVCXMLNamespaceDeclaration>)nspace;

- (id <GVCXMLContent>)nodeInstance:(NSString *)name attributes:(NSArray *)attArray inNamespace:(id <GVCXMLNamespaceDeclaration>)nspace;

- (id <GVCXMLCommentNode>)commentInstance:(NSString *)content;
- (id <GVCXMLTextContent>)textInstance:(NSString *)content;

- (id <GVCXMLProcessingInstructionsNode>)processingInstructionInstance:(NSString *)target forData:(NSString *)pidata;
@end
