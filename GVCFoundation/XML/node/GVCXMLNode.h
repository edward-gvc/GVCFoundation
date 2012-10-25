/*
 * GVCXMLNode.h
 * 
 * Created by David Aspinall on 12-03-13. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCXMLParsingModel.h"

@class GVCXMLGenerator;

@interface GVCXMLNode : NSObject <GVCXMLNamedContent, GVCXMLAttributeContainer>

	// GVCXMLContent
-(GVC_XML_ContentType)xmlType;

	// GVCXMLNamedContent
@property (readwrite, strong, nonatomic) NSString *localname;
@property (readwrite, strong, nonatomic) id <GVCXMLNamespaceDeclaration> defaultNamespace;
- (NSString *)qualifiedName;


	// GVCXMLAttributeContainer
- (NSArray *)attributes;
- (void)addAttribute:(id <GVCXMLAttributeContent>)attrb;
- (void)addAttribute:(NSString *)attrb withValue:(NSString *)attval inNamespace:(id <GVCXMLNamespaceDeclaration>)ns;
- (void)addAttributesFromArray:(NSArray *)attArray;
- (id <GVCXMLAttributeContent>)attributeForName:(NSString *)key;

- (void)generateOutput:(GVCXMLGenerator *)generator;

@end
