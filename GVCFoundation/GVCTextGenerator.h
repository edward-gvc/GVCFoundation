/*
 * GVCTextGenerator.h
 * 
 * Created by David Aspinall on 12-03-06. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@protocol GVCWriter;

@interface GVCTextGenerator : NSObject

@property (readonly, strong, nonatomic) id <GVCWriter> writer;

- initWithWriter:(id <GVCWriter>)wrter;

// open is also implied by the first call to write..
- (void)open;
- (void)close;

- (void)writeString:(NSString *)string;
- (void)writeFormat:(NSString *)fmt, ...;

@end
