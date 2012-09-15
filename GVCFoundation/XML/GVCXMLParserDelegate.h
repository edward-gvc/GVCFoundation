//
//  GVCXMLParserDelegate.h
//
//  Created by David Aspinall on 10-12-21.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCXMLParsingModel.h"

typedef enum _GVCXMLParserDelegate_Status 
{
	GVCXMLParserDelegate_Status_INITIAL,
	GVCXMLParserDelegate_Status_PROCESSING,
	GVCXMLParserDelegate_Status_SUCCESS,
	GVCXMLParserDelegate_Status_FAILURE,
	GVCXMLParserDelegate_Status_PARSE_FAILED,
	GVCXMLParserDelegate_Status_VALIDATION_FAILED
} GVCXMLParserDelegate_Status;

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
	
	GVCXMLParserDelegate_Status status;
	NSError *xml;
}

- (id)init;
- (void)resetParser;
- (BOOL)isReady;

@property (strong, nonatomic) NSString *filename;
@property (strong, nonatomic) NSURL *sourceURL;
@property (strong, nonatomic) NSData *xmlData;

@property (strong, nonatomic) NSError *xmlError;

- (NSData *)currentCDATA;
- (NSString *)currentTextString;
- (NSString *)currentNodeName;

- (GVCXMLParserDelegate_Status)status;
- (GVCXMLParserDelegate_Status)parse;

@end
