/*
 * GVCConfiguration.m
 * 
 * Created by David Aspinall on 12-05-12. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCConfiguration.h"

#import "GVCFunctions.h"
#import "GVCDirectory.h"
#import "GVCFileOperation.h"
#import "NSBundle+GVCFoundation.h"
#import "NSString+GVCFoundation.h"
#import "NSFileManager+GVCFoundation.h"

@interface GVCConfiguration ()
{
    __block NSInteger activeDownloads;
}
@property (strong, nonatomic) NSString *baseURL;
@property (strong, nonatomic) NSMutableDictionary *properties;
@property (strong, nonatomic) NSMutableDictionary *resourceDictionary;
@property (strong, nonatomic) NSMutableDictionary *resourceGroupDictionary;

- (void)checkLocalConfiguration;
- (void)processProperties:(NSDictionary *)propDict;
- (void)processResources:(NSDictionary *)propDict;
- (void)processRemoteResources:(NSDictionary *)propDict;

- (void)setActiveDownloads:(NSInteger)val;
- (void)increaseActiveDownloads;
- (void)decreaseActiveDownloads;
//- (void)loadResource:(NSString *)filename withExtension:(NSString *)ext bundle:(NSString *)bundleName toDirectory:(GVCDirectory *)docs;
@end

GVC_DEFINE_STR(GVCConfiguration_sourceURL)

GVC_DEFINE_STRVALUE(GVCConfiguration_LOCAL_INITIAL_FILE, LocalConfiguration.plist)
GVC_DEFINE_STRVALUE(GVCConfiguration_INITIAL_FILE, Configuration.plist)

GVC_DEFINE_STRVALUE(GVCConfiguration_plist_CONFIG_PROPERTIES, CONFIG_PROPERTIES)
GVC_DEFINE_STRVALUE(GVCConfiguration_plist_CONFIG_RESOURCE, CONFIG_RESOURCE)
GVC_DEFINE_STRVALUE(GVCConfiguration_plist_CONFIG_RESOURCE_BUNDLE_CLASS, CONFIG_RESOURCE_BUNDLE_CLASS)
GVC_DEFINE_STRVALUE(GVCConfiguration_plist_CONFIG_RESOURCE_FILENAME, CONFIG_RESOURCE_FILENAME)
GVC_DEFINE_STRVALUE(GVCConfiguration_plist_CONFIG_RESOURCE_EXT, CONFIG_RESOURCE_EXT)
GVC_DEFINE_STRVALUE(GVCConfiguration_plist_CONFIG_RESOURCE_PATH, CONFIG_RESOURCE_PATH)
GVC_DEFINE_STRVALUE(GVCConfiguration_plist_CONFIG_RESOURCE_URL, CONFIG_RESOURCE_URL)
GVC_DEFINE_STRVALUE(GVCConfiguration_plist_CONFIG_RESOURCE_MD5, CONFIG_RESOURCE_MD5)

@implementation GVCConfiguration

GVC_SINGLETON_CLASS(GVCConfiguration)

@synthesize baseURL;
@synthesize properties;
@synthesize resourceDictionary;
@synthesize resourceGroupDictionary;

@synthesize lastModifiedDate;
@synthesize operationQueue;

static dispatch_queue_t activeDownloadCounter = NULL;

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
        activeDownloadCounter = dispatch_queue_create("net.global-village.configCounter", DISPATCH_QUEUE_SERIAL);
        
        [self setActiveDownloads:-1];
        [self setProperties:[[NSMutableDictionary alloc] initWithCapacity:10]];
        [self setResourceDictionary:[[NSMutableDictionary alloc] initWithCapacity:10]];
        
        NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
        if ( gvc_IsEmpty([self baseURL]) == YES )
        {
            // should be something like
            // https://apps.global-village.net/mobile_configuration/<bundleIdentifier>/<appVersion/
            NSString *newBase = GVC_SPRINTF(@"http://localhost/~daspinall/mobile_configuration/%@", [[NSBundle mainBundle] gvc_bundleIdentifier]);
            [self setBaseURL:newBase];
            [usrDef setValue:newBase forKey:GVCConfiguration_sourceURL];
        }
	}
	
    return self;
}

- (void)setActiveDownloads:(NSInteger)val
{
    dispatch_async(activeDownloadCounter, ^{
        activeDownloads = val;
    });
}
- (void)increaseActiveDownloads
{
    dispatch_async(activeDownloadCounter, ^{
        activeDownloads ++;
        GVCLogError(@"Active Downloads %d", activeDownloads);
    });
}
- (void)decreaseActiveDownloads
{
    dispatch_async(activeDownloadCounter, ^{
        activeDownloads --;
        GVCLogError(@"Active Downloads %d", activeDownloads);
    });
}

- (BOOL)hasCompletedLoad
{
    return activeDownloads == 0;
}

- (void)reloadConfiguration
{
    [self setActiveDownloads:-1];
    [self checkLocalConfiguration];
    
    if (([self operationQueue] != nil) && (gvc_IsEmpty([self baseURL]) == NO))
    {
        // get the base configuration file
        NSURL *url = [NSURL URLWithString:GVC_SPRINTF(@"%@/%@", [self baseURL], GVCConfiguration_INITIAL_FILE)];
        
        GVCNetOperation *configOp = [[GVCNetOperation alloc] initForURL:url];
        [configOp setDidFinishBlock:^(GVCOperation *operation) {
            GVCMemoryResponseData *responseData = (GVCMemoryResponseData *)[(GVCNetOperation *)operation responseData];
            NSData *data = [responseData responseBody];
            NSError *plistError = nil;
            NSObject *plist = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:&plistError];
            if ( plist != nil )
            {
                [self processProperties:[plist valueForKey:GVCConfiguration_plist_CONFIG_PROPERTIES]];
                [self processRemoteResources:[plist valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE]];
            }
            else 
            {
                GVCLogError(@"Error loading %@ %@", GVCConfiguration_LOCAL_INITIAL_FILE, plistError);
            }
        }];
        [configOp setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
            GVCLogError(@"Operation Failed %@", err);
        }];
        [[self operationQueue] addOperation:configOp];
    }
}

- (NSString *)configurationPropertyForKey:(NSString *)key
{
    return [properties valueForKey:key];
}

- (NSString *)configurationResourcePathForKey:(NSString *)key
{
    return [resourceDictionary valueForKey:key];
}

- (NSArray *)configurationResourceKeysForGroup:(NSString *)key
{
    NSSet *set = [resourceGroupDictionary valueForKey:key];
    return (gvc_IsEmpty(set) ? nil : [set allObjects]);
}

- (void)checkLocalConfiguration
{
    NSString *localConfigPath = [[NSBundle mainBundle] pathForResource:GVCConfiguration_LOCAL_INITIAL_FILE ofType:nil];
    if ( gvc_IsEmpty(localConfigPath) == NO )
    {
        NSError *plistError = nil;
        NSData *data = [NSData dataWithContentsOfFile:localConfigPath];
        NSDictionary *plist = (NSDictionary *)[NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:&plistError];
        if ( plist != nil )
        {
            [self processProperties:[plist valueForKey:GVCConfiguration_plist_CONFIG_PROPERTIES]];
            [self processResources:[plist valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE]];
        }
        else 
        {
            GVCLogError(@"Error loading %@ %@", GVCConfiguration_LOCAL_INITIAL_FILE, plistError);
        }
    }
    else 
    {
        GVCLogInfo(@"No local configuration file named %@", GVCConfiguration_LOCAL_INITIAL_FILE );
    }
}

- (void)processProperties:(NSDictionary *)propDict
{
    if ( gvc_IsEmpty(propDict) == NO)
    {
        [[self properties] addEntriesFromDictionary:propDict];
    }
}

- (void)processResources:(NSDictionary *)propDict
{
    if ( gvc_IsEmpty(propDict) == NO)
    {
        for (NSString *resourceGroup in propDict )
        {
            NSArray *group = [propDict valueForKey:resourceGroup];
            NSMutableSet *groupSet = [resourceGroupDictionary valueForKey:resourceGroup];
            if ( groupSet == nil )
            {
                groupSet = [[NSMutableSet alloc] initWithCapacity:[group count]];
                [resourceGroupDictionary setObject:groupSet forKey:resourceGroup];
            }

            for ( NSDictionary *resource in group)
            {
                NSString *filename = [[resource valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE_FILENAME] lastPathComponent];
                NSString *subpath = [[resource valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE_FILENAME] stringByDeletingLastPathComponent];
                NSString *ext = [resource valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE_EXT];
                NSBundle *rscBundle = [NSBundle mainBundle];
                if ( gvc_IsEmpty([resource valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE_BUNDLE_CLASS]) == NO)
                {
                    Class bundleClass = NSClassFromString([resource valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE_BUNDLE_CLASS]);
                    rscBundle = [NSBundle bundleForClass:bundleClass];
                }

                if ( rscBundle != nil )
                {
                    NSString *localPath = [rscBundle pathForResource:[filename lastPathComponent] ofType:ext inDirectory:subpath];
                    if ( localPath != nil )
                    {
                        [resourceDictionary setObject:localPath forKey:[filename stringByAppendingPathExtension:ext]];
                        [groupSet addObject:[filename stringByAppendingPathExtension:ext]];
                    }
                    else
                    {
                        GVCLogError(@"Failed to find resource %@  %@/%@.%@", rscBundle, subpath, filename, ext);
                    }
                }
                else 
                {
                    GVCLogError(@"Failed to find class %@ for resource %@.%@", [resource valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE_BUNDLE_CLASS], filename, ext);
                }
            }
        }
    }
}

//- (void)loadResource:(NSString *)filename withExtension:(NSString *)ext bundle:(NSString *)bundleClassName toDirectory:(GVCDirectory *)docs
//{
//    NSBundle *rscBundle = [NSBundle mainBundle];
//    if ( gvc_IsEmpty(bundleClassName) == NO)
//    {
//        Class bundleClass = NSClassFromString(bundleClassName);
//        rscBundle = [NSBundle bundleForClass:bundleClass];
//    }
//    
//    if ( rscBundle != nil )
//    {
//        NSFileManager *fileMgr = [NSFileManager defaultManager];
//        NSString *subpath = [filename stringByDeletingLastPathComponent];
//        NSString *localPath = [rscBundle pathForResource:[filename lastPathComponent] ofType:ext inDirectory:subpath];
//        if ( localPath != nil )
//        {
//            NSString *sourceHash = [fileMgr gvc_md5Hash:localPath];
//            GVCDirectory *finalDir = docs;
//            if ( subpath != nil )
//            {
//                finalDir = [docs createSubdirectory:subpath];
//            }
//            NSString *finalPath = [finalDir fullpathForFile:GVC_SPRINTF(@"%@.%@", [filename lastPathComponent], ext)];
//            if (([fileMgr fileExistsAtPath:finalPath] == NO) || ([fileMgr gvc_validateFile:finalPath withMD5Hash:sourceHash] == NO))
//            {
//                GVCLogError(@"Finalpath %@", finalPath);
//                [fileMgr copyItemAtPath:localPath toPath:finalPath error:nil];
//            }
//            else
//            {
//                GVCLogError(@"Finalpath %@ hashes match", finalPath, sourceHash);
//            }
//        }
//        else
//        {
//            GVCLogError(@"Failed to find resource %@  %@/%@.%@", rscBundle, subpath, [filename lastPathComponent], ext);
//        }
//    }
//    else 
//    {
//        GVCLogError(@"Failed to find class %@ for resource %@.%@", bundleClassName, filename, ext);
//    }
//}

- (void)processRemoteResources:(NSDictionary *)propDict
{
    // no downloads required
    [self setActiveDownloads:0];

    if ( gvc_IsEmpty(propDict) == NO)
    {
        for (NSString *resourceGroup in propDict )
        {
            NSArray *group = [propDict valueForKey:resourceGroup];
            NSMutableSet *groupSet = [resourceGroupDictionary valueForKey:resourceGroup];
            if ( groupSet == nil )
            {
                groupSet = [[NSMutableSet alloc] initWithCapacity:[group count]];
                [resourceGroupDictionary setObject:groupSet forKey:resourceGroup];
            }
            
            for ( NSDictionary *resource in group)
            {
                NSString *remotePath = [resource valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE_PATH];
                NSString *remoteURL = [resource valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE_URL];
                if ((gvc_IsEmpty(remoteURL) == YES) && (gvc_IsEmpty(remotePath) == NO))
                {
                    remoteURL = GVC_SPRINTF(@"%@/%@", [self baseURL], remotePath);
                }
                NSURL *url = [NSURL URLWithString:remoteURL];
                if ( url != nil )
                {
                    // create a local destination path
                    NSString *filename = [url lastPathComponent];
                    NSString *cached = [[[GVCDirectory CacheDirectory] createSubdirectory:resourceGroup] fullpathForFile:filename];
                    NSString *temp = [[GVCDirectory TempDirectory] fullpathForFile:[NSString gvc_StringWithUUID]];

                    GVCNetOperation *rscDownload = [[GVCNetOperation alloc] initForURL:url];
                    [rscDownload setResponseData:[[GVCStreamResponseData alloc] initForFilename:temp]];
                    [rscDownload setDidFinishBlock:^(GVCOperation *operation) {
                        
                        NSFileManager *fileMgr = [NSFileManager defaultManager];
                        NSString *newFileHash = [fileMgr gvc_md5Hash:temp];
                        if (([fileMgr fileExistsAtPath:cached] == NO) || ([fileMgr gvc_validateFile:cached withMD5Hash:newFileHash] == NO))
                        {
                            GVCLogError(@"cached %@", cached);
                            NSError *mvErr = nil;
                            if ([fileMgr moveItemAtPath:temp toPath:cached error:&mvErr] == YES )
                            {
                                // success !
                                [resourceDictionary setObject:cached forKey:filename];
                                [groupSet addObject:filename];
                            }
                            else
                            {
                                GVCLogError(@"Move file error %@", mvErr);
                            }
                        }
                        else
                        {
                            GVCLogError(@"Finalpath %@ hashes match %@", cached, newFileHash);
                        }
                    }];
                    
                    [rscDownload setDidStartBlock:^(GVCOperation *operation) {
                        [self increaseActiveDownloads];
                    }];
                    [rscDownload setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
                        GVCLogError(@"Operation Failed %@", err);
                        [self decreaseActiveDownloads];
                    }];
                    [[self operationQueue] addOperation:rscDownload];
                }
            }
        }
    }
}

@end
