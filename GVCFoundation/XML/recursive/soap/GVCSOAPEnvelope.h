/*
 * GVCSOAPEnvelope.h
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCXMLRecursiveNode.h"
#import "GVCMacros.h"

GVC_DEFINE_EXTERN_STR(GVCSOAPEnvelope_elementname);

@class GVCSOAPHeader;
@class GVCSOAPBody;

/**
 * SOAP Envelope
 */
@interface GVCSOAPEnvelope : GVCXMLRecursiveNode

@property (strong, nonatomic) GVCSOAPHeader *header;
@property (strong, nonatomic) GVCSOAPBody *body;

@end
