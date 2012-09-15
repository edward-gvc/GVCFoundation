/*
 * GVCFileWriter.h
 * 
 * Created by David Aspinall on 11-11-25. 
 * Copyright (c) 2011 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

#import "GVCReaderWriter.h"

/**
 * \addtogroup operations
 *@{
 */
@interface GVCFileWriter : NSObject <GVCWriter, NSStreamDelegate>

+ (GVCFileWriter *)writerForFilename:(NSString *)file;
+ (GVCFileWriter *)writerForFilename:(NSString *)file encoding:(NSStringEncoding)encoding;

- (id)init;
- (id)initForFilename:(NSString *)file;
- (id)initForFilename:(NSString *)file encoding:(NSStringEncoding)encoding;

/**
 * \addtogroup filesstuff Stuff for files
 * \brief file handing methods
 * \param a Integer value.
 */
/**@{*/
@property (strong, nonatomic) NSString *filename;
@property (strong, nonatomic) NSOutputStream *fileStream;
/**@}*/

@property (nonatomic, readonly) GVCWriterStatus writerStatus;
@property (nonatomic, readonly) NSStringEncoding stringEncoding;
@end
/**@}*/
