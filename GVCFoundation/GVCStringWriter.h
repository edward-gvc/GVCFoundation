//
//  GVCStringWriter.h
//  HL7ParseTest
//
//  Created by David Aspinall on 11-01-02.
//  Copyright 2011 My Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCReaderWriter.h"

@interface GVCStringWriter : NSObject <GVCWriter>

+ (GVCStringWriter *)stringWriter;

- (NSString *)string;

@property (nonatomic, readonly) GVCWriterStatus writerStatus;
@property (nonatomic, readonly) NSStringEncoding stringEncoding;

@end
