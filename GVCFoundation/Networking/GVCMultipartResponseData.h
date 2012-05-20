/*
 * GVCMultipartResponseData.h
 * 
 * Created by David Aspinall on 12-05-13. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCNetResponseData.h"

@interface GVCMultipartResponseData : GVCMemoryResponseData

- initForFilename:(NSString *)fName;

// either a stream or a filename is required
@property (strong, nonatomic) NSString *responseFilename;

- (NSArray *)responseParts;

@end
