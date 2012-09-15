/*
 * GVCXMLDigestOperation.h
 * 
 * Created by David Aspinall on 12-03-27. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCOperation.h"

@class GVCXMLParserDelegate;

/**
 * XML parsing operation.
 */
@interface GVCXMLParserOperation : GVCOperation

- initForParser:(GVCXMLParserDelegate *)dgst;

@property (strong, nonatomic) GVCXMLParserDelegate *xmlParser;

@end
