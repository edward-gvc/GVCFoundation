/*
 * GVCXMLRecursiveNode.h
 * 
 * Created by David Aspinall on 2012-10-27. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCXMLRecursiveParserBase.h"

#import "GVCXMLGenerator.h"

/**
 * <#description#>
 */
@interface GVCXMLRecursiveNode : GVCXMLRecursiveParserBase <GVCXMLContent, GVCXMLGeneratorProtocol>

/**
 * the default selector will be the  element name, as a setXxx or addXxx.  For example if the element being processed has a local name of "faultcode" then the default behaviour checks to see if self responds to setFaultCode: or addFaultCode:
 * Subclasses may return any single argument selector that is appropriate, but cannot return nil.
 * @param node the GVCXMLRecursive node that will be set on self
 * @returns SEL selector
 */
- (SEL)currentSetNodeSelectorKey:(GVCXMLRecursiveNode *)node;

/**
 * Class name to instantiate for the currently parsed element name.  Default behaviour returns 'elementName' as class name 'ElementName'
 * @param elementName the name of the current element
 * @param namespaceURI the current namespace URI for the element, without the prefix
 * @returns the class name or nil if the node is text only as should just set a property
 */
- (NSString *)nodeClassNameForElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI;

/**
 * This method takes the class created by nodeClassNameForElement:namespaceURI: and sends a [self invokeSelector:[self currentSetNodeSelectorKey:] withObject:node]
 * @param node the node to set on the current object
 */
- (void)processCurrentNode:(GVCXMLRecursiveNode *)node;

/**
 *
 */
- (void)processCurrentTextContent;
- (void)processCurrentTextContentForSelector:(SEL)aSelector;

@property (strong, nonatomic) NSString *localname;
@property (strong, nonatomic) NSDictionary *attributes;
@property (readwrite, strong, nonatomic) id <GVCXMLNamespaceDeclaration> defaultNamespace;

- (NSString *)defaultNamespacePrefix;
- (NSString *)qualifiedName;

- (NSDictionary *)declaredNamespaces;
- (void)declareNamespace:(NSString *)prefix forURI:(NSString *)uri;
- (BOOL)isNamespaceInScope:(NSString *)prefix;
- (id <GVCXMLNamespaceDeclaration>)namespaceInScope:(NSString *)prefix;

- (void)generateOutput:(GVCXMLGenerator *)generator;

@end
