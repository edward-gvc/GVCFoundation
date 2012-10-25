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
@class GVCXMLGenerator;

@interface GVCXMLDocument : NSObject <GVCXMLDocumentNode>
{
	id <GVCXMLDocumentTypeDeclaration> documentType;	
	NSString *baseURL;
	
	GVCStack *nodeStack;
}

- (id)init;

@property (strong, nonatomic) id <GVCXMLDocumentTypeDeclaration> documentType;
@property (strong, nonatomic) NSString *baseURL;
@property (strong, nonatomic) GVCStack *nodeStack;

- (id <GVCXMLContent>)nodeForPath:(NSString *)path;

- (void)generateOutput:(GVCXMLGenerator *)generator;
@end
