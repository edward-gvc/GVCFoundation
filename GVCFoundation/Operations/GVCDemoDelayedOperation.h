/**
 * GVCDemoDelayedOperation
 *
 * Copyright (c) 2010-2012 Global Village Consulting.
 * All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

#import "GVCOperation.h"
#import "GVCNetResponseData.h"

/**
 * Operation designed to simulate a delayed processing.  Commonly used for simulated Network operations.
 */
@interface GVCDemoDelayedOperation : GVCOperation

/**
 * designated intializer
 * @param filename the full path to the data that will be used to simulate the response
 */
- initWithResponseFile:(NSString *)filename;

- initWithResponseFile:(NSString *)filename withDUID:(NSString*) duid andRUID: (NSString*) ruid;

/** Response data for the simulated operation */
@property (strong, nonatomic)  GVCNetResponseData *responseData;   


@end
