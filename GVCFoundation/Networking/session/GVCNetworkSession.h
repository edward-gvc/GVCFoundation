/*
 * GVCNetworkSession.h
 * 
 * Created by David Aspinall on 2012-10-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

/**
 * Generalized network session support
 */
@interface GVCNetworkSession : NSObject

- (id)initForBaseURL:(NSURL *)url;

/**
 * base url is a required initialization parameter
 * @returns the session base url
 */
@property (strong, nonatomic, readonly) NSURL *baseURL;

/**
 * Operation queue for work operations.  If none is specified then one is allocated
 */
@property (strong, nonatomic) NSOperationQueue *queue;

/** Indicates whether the session is open and ready for use. */
@property(readonly) BOOL isOpen;

@end
