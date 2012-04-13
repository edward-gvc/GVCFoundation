//
//  GVCXMLParseNodeDelegate.h
//
//  Created by David Aspinall on 10-12-21.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVCXMLParserDelegate.h"
#import "GVCXMLParsingModel.h"

@interface GVCXMLParseNodeDelegate : NSObject  <NSXMLParserDelegate>
{
	GVCStack *nodeStack;
	NSMutableDictionary *namespaceStack;
	NSMutableArray *declaredNamespaces;
	
	NSString *filename;
	NSURL *sourceURL;
    NSData *xmlData;	
	
	id <GVCXMLDocumentNode> documentNode;
	GVC_XML_ParserDelegateStatus status;
}

- (id)init;
- (void)resetParser;

@property (strong, nonatomic) NSString *filename;
@property (strong, nonatomic) NSURL *sourceURL;
@property (strong, nonatomic) NSData *xmlData;

- (id <GVCXMLDocumentNode>)document;

- (GVC_XML_ParserDelegateStatus)status;
- (GVC_XML_ParserDelegateStatus)parse;

@end
