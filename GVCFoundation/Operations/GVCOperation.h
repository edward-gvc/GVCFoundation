//
//  GVCOperation.h
//
//  Created by David Aspinall on 10-01-31.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCMacros.h"

@class GVCOperation;


GVC_DEFINE_EXTERN_STR(GVCOperationErrorDomain);

typedef enum 
{
    GVC_Operation_ErrorType_CANCELLED = 1,
	GVC_Operation_ErrorType_UNHANDLED
} GVC_Operation_ErrorType;

typedef enum 
{
	GVC_Operation_Type_NORMAL = 0,
	GVC_Operation_Type_CORE_DATA,
	GVC_Operation_Type_NETWORK
} GVC_Operation_Type;

typedef void (^GVCOperationBlock)(GVCOperation *operation);
typedef void (^GVCOperationErrorBlock)(GVCOperation *operation, NSError* error);


@interface GVCOperation : NSOperation

// Performed on the main thread.
@property (readwrite, copy) GVCOperationBlock didStartBlock;
@property (readwrite, copy) GVCOperationBlock didFinishBlock;
@property (readwrite, copy) GVCOperationErrorBlock didFailWithErrorBlock;

// Performed on the operation thread.
@property (readwrite, copy) GVCOperationBlock willFinishBlock;

@property (strong) NSError *operationError;

- (GVC_Operation_Type)operationType;
- (void)operationDidStart;
- (void)operationDidFinish;
- (void)operationDidFailWithError:(NSError *)error;
- (void)operationWillFinish;

@end

