/*
 * GVCSOAPSession.h
 * 
 * Created by David Aspinall on 2012-10-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCHTTPSession.h"

@class GVCSOAPAction;

/**
 * Extends the HTTP session for SOAP specific headers and post processing
 */
@interface GVCSOAPSession : GVCHTTPSession

- (id)initForBaseURL:(NSURL *)url;

- (void)performAction:(GVCSOAPAction *)action completion:(GVCSessionActionCompleteBlock)block;
@end
