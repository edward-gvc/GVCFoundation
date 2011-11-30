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
{
	GVCWriterStatus writerStatus;
	NSStringEncoding stringEncoding;
	dispatch_group_t group;
	
    NSFileHandle	*log;
    NSString		*logPath;
}

+ (GVCFileHandleWriter *)writerForFileHandle:(NSFileHandle *)file;
+ (GVCFileHandleWriter *)writerForFileHandle:(NSFileHandle *)file encoding:(NSStringEncoding)encoding;

- (id)init;
- (id)initForFileHandle:(NSFileHandle *)file;
- (id)initForFileHandle:(NSFileHandle *)file encoding:(NSStringEncoding)encoding;
- (id)initForFilename:(NSString *)file encoding:(NSStringEncoding)encoding;

@property (retain, nonatomic) NSString *logPath;
@property (retain, nonatomic) NSFileHandle	*log;

/*
 * String encoding when writer is generating for destinations where the encoding can be used.
 */
- (NSStringEncoding)stringEncoding;

/*
 * String encoding when writer is generating for destinations where the encoding can be used.
 */
- (void)setStringEncoding:(NSStringEncoding)encode;

@end
