/*
 * XSDParserDelegate.h
 * 
 * Created by David Aspinall on 2012-10-25. 
 * Copyright (c) 2012 Global Village. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

#import "GVCXMLParserDelegate.h"

@class GVCXMLGenerator;
@class GVCStack;

/**
 * <#description#>
 */
@interface GVCParseBase : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) GVCParseBase *parent;
- (void)reset;

@property (strong, nonatomic) GVCStack *elementStack;
- (NSString *)peekTopElementName;
- (NSString *)elementNamePath:(NSString *)separator;
@end



@interface GVCParseNode : GVCParseBase

- (NSString *)currentGetTextSelectorKey;
- (NSString *)currentSetTextSelectorKey;
- (NSString *)currentGetNodeSelectorKey;
- (NSString *)currentSetNodeSelectorKey;
- (NSString *)currentTextContent;

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




@interface GVCBaseParserDelegate : GVCParseBase <GVCXMLParserProtocol>

@property (strong, nonatomic) GVCParseNode *document;

@property (assign, nonatomic, readonly) GVCXMLParserDelegate_Status status;
@property (strong, nonatomic) NSError *xmlError;
- (BOOL)isReady;

@property (strong, nonatomic) NSString *xmlFilename;
@property (strong, nonatomic) NSURL *xmlSourceURL;
@property (strong, nonatomic) NSData *xmlData;

- (GVCXMLParserDelegate_Status)parse:(NSXMLParser *)parser;
- (GVCXMLParserDelegate_Status)parse;

@end

