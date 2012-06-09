//
//  GVCDemoDelayedOperation.h
//
//  Created by David Aspinall on 11-07-08.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVCOperation.h"
#import "GVCNetResponseData.h"

@interface GVCDemoDelayedOperation : GVCOperation

- initWithResponseFile:(NSString *)filename;

@property (strong, nonatomic)  GVCMemoryResponseData *responseData;   

@end
