//
//  DAXMLDocument.h
//
//  Created by David Aspinall on 21/01/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCMacros.h"
#import "GVCXMLParsingModel.h"

@class GVCXMLDocType;

@interface GVCXMLDocument : NSObject <GVCXMLDocumentNode>
{
	id <GVCXMLDocumentTypeDeclaration> documentType;	
	NSString *baseURL;
	
	GVCStack *nodeStack;
}

- (id)init;

@property (retain, nonatomic) id <GVCXMLDocumentTypeDeclaration> documentType;
@property (retain, nonatomic) NSString *baseURL;
@property (retain, nonatomic) GVCStack *nodeStack;

// XMLParentProtocol
//- (int)indexOf:(id <XMLContent>) child;
//- (id <XMLContent>)contentAtIndex:(int) idx;
//
//- (NSArray *)nodeStack;
//- (id <XMLContent>)addContent:(id <XMLContent>) child;
//
//- (void)removeAllContent;
//- (void)removeContent:(id <XMLContent>) child;
//- (void)removeContentAtIndex:(int) idx;
//- (void)replaceContentAtIndex:(int) idx with:(id <XMLContent>) child;

@end
