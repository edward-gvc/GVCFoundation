/*
 * GVCFileHandleWriter.h
 * 
 * Created by David Aspinall on 11-11-25. 
 * Copyright (c) 2011 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
# import <dispatch/dispatch.h>

#import "GVCReaderWriter.h"

@interface GVCFileHandleWriter : NSObject <GVCWriter>

+ (GVCFileHandleWriter *)writerForFileHandle:(NSFileHandle *)file;
+ (GVCFileHandleWriter *)writerForFileHandle:(NSFileHandle *)file encoding:(NSStringEncoding)encoding;

- (id)init;
- (id)initForFileHandle:(NSFileHandle *)file;
- (id)initForFileHandle:(NSFileHandle *)file encoding:(NSStringEncoding)encoding;
- (id)initForFilename:(NSString *)file encoding:(NSStringEncoding)encoding;

- (NSURL *)logPathURL;

@property (strong, nonatomic) NSString *logPath;
@property (strong, nonatomic) NSFileHandle	*log;

@property (nonatomic, assign, readonly) GVCWriterStatus writerStatus;
@property (nonatomic, assign, readonly) NSStringEncoding stringEncoding;

@end
