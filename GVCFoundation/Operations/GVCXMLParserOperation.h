/*
 * GVCXMLDigestOperation.h
 * 
 * Created by David Aspinall on 12-03-27. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCOperation.h"

@protocol GVCXMLParserProtocol;

/**
 * XML parsing operation.
 */
@interface GVCXMLParserOperation : GVCOperation

- initForParser:(id <GVCXMLParserProtocol>)dgst;

@property (strong, nonatomic) id <GVCXMLParserProtocol>xmlParser;

@end
