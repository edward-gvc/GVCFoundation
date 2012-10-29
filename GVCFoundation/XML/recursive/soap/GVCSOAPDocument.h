/*
 * GVCSOAPDocument.h
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCXMLRecursiveNode.h"

@class GVCSOAPFault;
@class GVCSOAPEnvelope;
@class GVCSOAPBody;
@class GVCStack;

/**
 * <#description#>
 */
@interface GVCSOAPDocument : GVCXMLRecursiveNode <GVCXMLDocumentNode>

- (id)init;

#pragma mark - GVCXMLDocumentNode protocol
@property (strong, nonatomic) id <GVCXMLDocumentTypeDeclaration> documentType;
@property (strong, nonatomic) NSString *baseURL;
@property (strong, nonatomic) GVCStack *nodeStack;

- (NSArray *)contentArray;
- (id <GVCXMLContent>)addContent:(id <GVCXMLContent>) child;

#pragma mark - GVCXMLGenerator protocol
- (void)generateOutput:(GVCXMLGenerator *)generator;

#pragma mark - SOAP
- (GVCSOAPEnvelope *)envelope;
- (GVCSOAPBody *)body;
- (NSArray *)envelopeBodyContent;

- (BOOL)isFault;
- (GVCSOAPFault *)faultNode;

#pragma mark - convenient message construction
- (GVCXMLRecursiveNode *)addSOAPBodyContent:(GVCXMLRecursiveNode *)msg;
@end
