//
//  DADiskOperation.h
//
//  Created by David Aspinall on 10-03-18.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCOperation.h"

typedef enum 
{
    GVC_FileOperation_Type_CREATE = 1,
    GVC_FileOperation_Type_COPY,
    GVC_FileOperation_Type_MOVE,
    GVC_FileOperation_Type_DELETE,
    GVC_FileOperation_Type_APPEND,
    GVC_FileOperation_Type_OVERWRITE,
	GVC_FileOperation_Type_UNKNOWN
} GVC_FileOperation_Type;

GVC_DEFINE_EXTERN_STR( GVCFileOperationErrorDomain )

@interface GVCFileOperation : GVCOperation

+ (GVCFileOperation *)saveData:(NSData *)data toPath:(NSString *)path;
+ (GVCFileOperation *)duplicateFile:(NSString *)src toPath:(NSString *)path;
+ (GVCFileOperation *)moveFile:(NSString *)src toPath:(NSString *)path;
+ (GVCFileOperation *)deleteFile:(NSString *)src;

- initForAction:(GVC_FileOperation_Type)atype;

@property (assign) GVC_FileOperation_Type action;

@property (strong, nonatomic) NSString *sourcePath;
@property (strong, nonatomic) NSData *sourceData;

@property (strong, nonatomic) NSString *targetPath;

@end
