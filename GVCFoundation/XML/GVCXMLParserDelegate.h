//
//  GVCXMLParserDelegate.h
//
//  Created by David Aspinall on 10-12-21.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCXMLParsingModel.h"

typedef enum _GVC_XML_ParserDelegateStatus 
{
	GVC_XML_ParserDelegateStatus_INITIAL,
	GVC_XML_ParserDelegateStatus_PROCESSING,
	GVC_XML_ParserDelegateStatus_SUCCESS,
	GVC_XML_ParserDelegateStatus_FAILURE,
	GVC_XML_ParserDelegateStatus_PARSE_FAILED,
	GVC_XML_ParserDelegateStatus_VALIDATION_FAILED
} GVC_XML_ParserDelegateStatus;

/*
	Basic XML parser delegate to handle the most common tasks
 */
@interface GVCXMLParserDelegate : NSObject  <NSXMLParserDelegate>
{
	GVCStack *elementNameStack;
	NSMutableDictionary *namespaceStack;
	NSMutableArray *declaredNamespaces;
	
	NSMutableString *currentTextBuffer;
	NSData *currentCDATA;
	
	NSString *filename;
	NSURL *sourceURL;
    NSData *xmlData;	
	
	GVC_XML_ParserDelegateStatus status;
	NSError *xmlError;
}

- (id)init;
- (void)resetParser;
- (BOOL)isReady;

@property (retain, nonatomic) NSString *filename;
@property (retain, nonatomic) NSURL *sourceURL;
@property (retain, nonatomic) NSData *xmlData;

@property (retain, nonatomic) NSError *xmlError;

- (NSData *)currentCDATA;
- (NSString *)currentTextString;

- (GVC_XML_ParserDelegateStatus)status;
- (GVC_XML_ParserDelegateStatus)parse;

@end
