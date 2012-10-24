/*
 * GVCHTTPSession.h
 * 
 * Created by David Aspinall on 2012-10-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCNetworkSession.h"

@class GVCHTTPAction;

/**
 * Session block executes when the requested action has complete.
 * @param action the action that finished
 */
typedef void (^GVCSessionActionCompleteBlock)(GVCHTTPAction *action);

/**
 * represents a multi-message HTTP session.  Stores cookies and cache's responses that can be used in furure requests
 */
@interface GVCHTTPSession : GVCNetworkSession

- (id)initForBaseURL:(NSURL *)url;

/**
 * creates and configures the NetOperation.  Calls the completion block when the action is finished.  Note the action may encompass multiple operations, the completion block is only called once.
 */
- (void)performAction:(GVCHTTPAction *)action completion:(GVCSessionActionCompleteBlock)block;

@end
