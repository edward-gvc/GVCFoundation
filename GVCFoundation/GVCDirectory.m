/*
 * GVCDirectory.m
 * 
 * Created by David Aspinall on 11-12-06. 
 * Copyright (c) 2011 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCDirectory.h"
#import "NSString+GVCFoundation.h"
#import "NSBundle+GVCFoundation.h"
#import "NSFileManager+GVCFoundation.h"

static GVCDirectory *tempDirectory;
static GVCDirectory *cacheDirectory;
static GVCDirectory *docsDirectory;
static GVCDirectory *downloadsDirectory;

@implementation GVCDirectory

+ (GVCDirectory *)TempDirectory
{
    static dispatch_once_t sharedTemp;
	dispatch_once(&sharedTemp, ^{
        
        NSFileManager *fileMgr = [NSFileManager defaultManager];
		NSString *systemTemp = [fileMgr gvc_temporaryDirectory];
		
#if !TARGET_OS_IPHONE
		NSString *name = GVC_SPRINTF( @"%@.XXXXXX", [NSBundle gvc_MainBundleIdentifier] );
		NSString *template = [systemTemp stringByAppendingPathComponent:name];
		const char * fsTemplate = [template fileSystemRepresentation];
		NSMutableData * bufData = [NSMutableData dataWithBytes:fsTemplate length:strlen(fsTemplate)+1];
		char * buffer = [bufData mutableBytes];
		
		if (mkdtemp(buffer) == NULL)
		{
			GVCLogError(@"Could not create temporary dir: %s, %s", buffer, strerror(errno));
			return nil;
		}
        systemTemp = [fileMgr stringWithFileSystemRepresentation:buffer length:strlen(buffer)];

#elif defined(TARGET_IPHONE_SIMULATOR)

        systemTemp = [systemTemp stringByAppendingPathComponent:[NSBundle gvc_MainBundleIdentifier]];
#endif

		NSError *error;
        if ( [fileMgr gvc_directoryExists:systemTemp] == NO)
		{
			[fileMgr createDirectoryAtPath:systemTemp withIntermediateDirectories:NO attributes:nil error:&error];
		}

        tempDirectory = [[GVCDirectory alloc] initWithRootPath:systemTemp];
	});

    return tempDirectory;
}

+ (GVCDirectory *)CacheDirectory
{
    static dispatch_once_t sharedCache;
	dispatch_once(&sharedCache, ^{
        
        NSFileManager *fileMgr = [NSFileManager defaultManager];
		NSString *systemTemp = [fileMgr gvc_cachesDirectory];
#if defined(TARGET_IPHONE_SIMULATOR)
        systemTemp = [systemTemp stringByAppendingPathComponent:[NSBundle gvc_MainBundleIdentifier]];
#endif
		NSError *error;
        if ( [fileMgr gvc_directoryExists:systemTemp] == NO)
		{
			[fileMgr createDirectoryAtPath:systemTemp withIntermediateDirectories:YES attributes:nil error:&error];
		}

        cacheDirectory = [[GVCDirectory alloc] initWithRootPath:systemTemp];
	});
    
    return cacheDirectory;
}

+ (GVCDirectory *)DocumentDirectory
{
    static dispatch_once_t sharedDoc;
	dispatch_once(&sharedDoc, ^{
        
        NSFileManager *fileMgr = [NSFileManager defaultManager];
		NSString *systemTemp = [fileMgr gvc_documentsDirectory];
#if defined(TARGET_IPHONE_SIMULATOR)
        systemTemp = [systemTemp stringByAppendingPathComponent:[NSBundle gvc_MainBundleIdentifier]];
#endif
		NSError *error;
        if ( [fileMgr gvc_directoryExists:systemTemp] == NO)
		{
			[fileMgr createDirectoryAtPath:systemTemp withIntermediateDirectories:YES attributes:nil error:&error];
		}
        
        docsDirectory = [[GVCDirectory alloc] initWithRootPath:systemTemp];
	});
    
    return docsDirectory;
}

+ (GVCDirectory *)DownloadDirectory
{
    static dispatch_once_t sharedDownloads;
	dispatch_once(&sharedDownloads, ^{
        
        NSFileManager *fileMgr = [NSFileManager defaultManager];
		NSString *systemTemp = [fileMgr gvc_downloadsDirectory];
#if defined(TARGET_IPHONE_SIMULATOR)
        systemTemp = [systemTemp stringByAppendingPathComponent:[NSBundle gvc_MainBundleIdentifier]];
#endif
		NSError *error;
        if ( [fileMgr gvc_directoryExists:systemTemp] == NO)
		{
			[fileMgr createDirectoryAtPath:systemTemp withIntermediateDirectories:YES attributes:nil error:&error];
		}
        
        downloadsDirectory = [[GVCDirectory alloc] initWithRootPath:systemTemp];
	});
    
    return downloadsDirectory;
}


@synthesize rootDirectory;

- (id)initWithRootPath:(NSString *)path
{
	self = [super init];
	if ( self != nil )
	{
        [self setRootDirectory:path];
	}
	
    return self;
}

- (GVCDirectory *)createSubdirectory:(NSString *)name
{
    NSString *full = [[self rootDirectory] stringByAppendingPathComponent:name];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if ( [fileMgr gvc_directoryExists:full] == NO )
    {
        [fileMgr createDirectoryAtPath:full withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return [[GVCDirectory alloc] initWithRootPath:full];
}

- (NSString *)fullpathForFile:(NSString *)filename
{
    GVC_ASSERT(gvc_IsEmpty(filename) == NO, @"Filename cannot be null");
    
	return [[self rootDirectory] stringByAppendingPathComponent:filename];
}

- (NSString *)uniqueFilename
{
    return [self uniqueFilename:nil];
}

- (NSString *)uniqueFilename:(NSString *)prefix
{
    NSString *tf = [NSString gvc_StringWithUUID];
	if ( gvc_IsEmpty(prefix) == NO )
	{
		tf = GVC_SPRINTF( @"%@.%@", prefix, tf );
	}
	return [self fullpathForFile:tf];
}

@end