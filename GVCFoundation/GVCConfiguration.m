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

#import "GVCConfigDocument.h"
#import "GVCConfigResource.h"
#import "GVCConfigPackage.h"
#import "GVCConfigProperty.h"

GVC_DEFINE_STRVALUE(GVCConfiguration_LOCAL_INITIAL_FILE, LocalConfiguration.xml)
GVC_DEFINE_STRVALUE(GVCConfiguration_REMOTE_FILE, RemoteConfiguration.xml)
GVC_DEFINE_STRVALUE(GVCConfiguration_CACHED_FILE, Configuration.xml)

@interface GVCConfiguration ()
{
    __block NSInteger activeDownloads;
}
@property (strong, nonatomic) NSString *baseURL;
@property (strong, nonatomic) GVCConfigDocument *consolidatedConfig;

@property (strong, nonatomic) NSMutableDictionary *properties;
@property (strong, nonatomic) NSMutableDictionary *resourceDictionary;
@property (strong, nonatomic) NSMutableDictionary *resourceGroupDictionary;

- (void)checkLocalConfiguration;
- (void)checkCachedRemoteFile;
//- (void)storeCachedConfiguration;

- (void)processProperties:(NSDictionary *)propDict;
- (void)processResources:(NSDictionary *)propDict;
- (void)processRemoteResources:(NSDictionary *)propDict;

- (void)setActiveDownloads:(NSInteger)val;
- (void)increaseActiveDownloads;
- (void)decreaseActiveDownloads;
@end

NSString * const GVCConfiguration_sourceURL = @"https://apps.global-village.net/mobile_configuration";

@implementation GVCConfiguration

GVC_SINGLETON_CLASS(GVCConfiguration)

@synthesize baseURL;
@synthesize properties;
@synthesize resourceDictionary;
@synthesize resourceGroupDictionary;
@synthesize consolidatedConfig;

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
	}
	
    return self;
}

- (GVCXMLDigester *)digester
{
    GVCXMLDigester *dgst = [[GVCXMLDigester alloc] init];
	[dgst addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCConfigDocument"] forNodeName:@"config"];
	[dgst addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCConfigSharedPackage"] forNodeName:@"shared"];
	[dgst addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCConfigPackage"] forNodeName:@"package"];
	[dgst addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCConfigProperty"] forNodeName:@"property"];
    [dgst addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCConfigResource"] forNodeName:@"resource"];

	[dgst addRule:[GVCXMLDigesterRule ruleForParentChild:@"sharedPackage"]  forNodeName:@"shared"];
	[dgst addRule:[GVCXMLDigesterRule ruleForParentChild:@"package"]  forNodeName:@"package"];
	[dgst addRule:[GVCXMLDigesterRule ruleForParentChild:@"property"]  forNodeName:@"property"];
	[dgst addRule:[GVCXMLDigesterRule ruleForParentChild:@"resource"]  forNodeName:@"resource"];
    	
	GVCXMLDigesterAttributeMapRule *configAttributes = [[GVCXMLDigesterAttributeMapRule alloc] initWithKeysAndValues:@"version", @"version", @"md5", @"md5", nil];
	[configAttributes setTryToAssignAll:YES];
	[dgst addRule:configAttributes forNodeName:@"config"];

	GVCXMLDigesterAttributeMapRule *propAttribute = [[GVCXMLDigesterAttributeMapRule alloc] initWithKeysAndValues:@"name", @"name", @"action", @"action", nil];
	[propAttribute setTryToAssignAll:YES];
	[dgst addRule:propAttribute forNodeName:@"property"];
    
	GVCXMLDigesterAttributeMapRule *pkgAttribute = [[GVCXMLDigesterAttributeMapRule alloc] initWithKeysAndValues:@"name", @"name", @"status", @"status", nil];
	[pkgAttribute setTryToAssignAll:YES];
	[dgst addRule:pkgAttribute forNodeName:@"package"];

    GVCXMLDigesterAttributeMapRule *resourceAttributes = [[GVCXMLDigesterAttributeMapRule alloc] initWithKeysAndValues:@"name", @"name", @"action", @"action", @"tag", @"tag", @"status", @"status", @"md5", @"md5", nil];
	[resourceAttributes setTryToAssignAll:YES];
	[dgst addRule:resourceAttributes forNodeName:@"resource"];

    GVCXMLDigesterSetPropertyRule *remote = [[GVCXMLDigesterSetPropertyRule alloc] initWithPropertyName:@"path"];
	[dgst addRule:remote forNodeName:@"resource"];

    GVCXMLDigesterSetPropertyRule *value = [[GVCXMLDigesterSetPropertyRule alloc] initWithPropertyName:@"value"];
	[dgst addRule:value forNodeName:@"property"];

    return dgst;
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
    
    // when the local configuration loads, there may be a new remote configuration URL
    [self checkLocalConfiguration];
    [self checkCachedRemoteFile]; 

//    // only need to test this once, the remote service is no allowed to change the location of the remote service, only a new build
//    if ( gvc_IsEmpty([self baseURL]) == YES )
//    {
//        NSString *newBase = [self configurationPropertyForKey:GVCConfiguration_plist_CONFIG_PROPERTIES_remote_url];
//        if ( gvc_IsEmpty(newBase) == YES )
//        {
//            // should be something like
//            // https://apps.global-village.net/mobile_configuration/<bundleIdentifier>/<appVersion/
//            newBase = GVCConfiguration_sourceURL;
//        }
//        [self setBaseURL:GVC_SPRINTF(@"%@/%@/%@", newBase, [NSBundle gvc_MainBundleIdentifier], [NSBundle gvc_MainBundleVersion])];
//    }
//
//    if (([self operationQueue] != nil) && (gvc_IsEmpty([self baseURL]) == NO))
//    {
//        // get the base configuration file
//        NSURL *url = [NSURL URLWithString:GVC_SPRINTF(@"%@/%@", [self baseURL], GVCConfiguration_INITIAL_FILE)];
//        
//        GVCNetOperation *configOp = [[GVCNetOperation alloc] initForURL:url];
//        [configOp setDidFinishBlock:^(GVCOperation *operation) {
//            GVCMemoryResponseData *responseData = (GVCMemoryResponseData *)[(GVCNetOperation *)operation responseData];
//            NSData *data = [responseData responseBody];
//            NSError *plistError = nil;
//            NSObject *plist = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:&plistError];
//            if ( plist != nil )
//            {
//                [self processProperties:[plist valueForKey:GVCConfiguration_plist_CONFIG_PROPERTIES]];
//                [self processRemoteResources:[plist valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE]];
//            }
//            else 
//            {
//                GVCLogError(@"Error loading %@ %@", GVCConfiguration_LOCAL_INITIAL_FILE, plistError);
//            }
//        }];
//        [configOp setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
//            GVCLogError(@"Operation Failed %@", err);
//        }];
//        [[self operationQueue] addOperation:configOp];
//    }
//    
//    [self storeCachedConfiguration];
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
        GVCXMLDigester *dgst = [self digester];
        [dgst setFilename:localConfigPath];
        GVC_XML_ParserDelegateStatus status = [dgst parse];
        if (status == GVC_XML_ParserDelegateStatus_SUCCESS)
        {
//            GVCConfigDocument *localDoc = [dgst digestValueForPath:@"config"];
//            GVCConfigSharedPackage *shared = [localDoc sharedPackage];
//            NSArray *packages = [localDoc allPackages];
        }
        else
        {
            GVCLogError( @"Parse Failed %@", [dgst xmlError]);
            GVC_ASSERT(NO, @"Parse Failed %@", [dgst xmlError]);
        }
    }
    else 
    {
        GVCLogInfo(@"No local configuration file named %@", GVCConfiguration_LOCAL_INITIAL_FILE );
    }
}

- (void)checkCachedRemoteFile
{
//    NSString *cached = [[GVCDirectory CacheDirectory] fullpathForFile:GVCConfiguration_CACHED_REMOTE_FILE];
//    if ( [[NSFileManager defaultManager] fileExistsAtPath:cached] == YES )
//    {
//        NSError *plistError = nil;
//        NSData *data = [NSData dataWithContentsOfFile:cached];
//        NSDictionary *plist = (NSDictionary *)[NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:&plistError];
//        if ( plist != nil )
//        {
//            [self processProperties:[plist valueForKey:GVCConfiguration_plist_CONFIG_PROPERTIES]];
//            [self processResources:[plist valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE]];
//        }
//        else 
//        {
//            GVCLogError(@"Error loading %@ %@", GVCConfiguration_LOCAL_INITIAL_FILE, plistError);
//        }
//    }
//    else 
//    {
//        GVCLogInfo(@"No local configuration file named %@", GVCConfiguration_LOCAL_INITIAL_FILE );
//    }
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
//    if ( gvc_IsEmpty(propDict) == NO)
//    {
//        for (NSString *resourceGroup in propDict )
//        {
//            NSArray *group = [propDict valueForKey:resourceGroup];
//            NSMutableSet *groupSet = [resourceGroupDictionary valueForKey:resourceGroup];
//            if ( groupSet == nil )
//            {
//                groupSet = [[NSMutableSet alloc] initWithCapacity:[group count]];
//                [resourceGroupDictionary setObject:groupSet forKey:resourceGroup];
//            }
//
//            for ( NSDictionary *resource in group)
//            {
//                NSString *filename = [[resource valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE_FILENAME] lastPathComponent];
//                NSString *subpath = [[resource valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE_FILENAME] stringByDeletingLastPathComponent];
//                NSString *ext = [resource valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE_EXT];
//                NSBundle *rscBundle = [NSBundle mainBundle];
//                if ( gvc_IsEmpty([resource valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE_BUNDLE_CLASS]) == NO)
//                {
//                    Class bundleClass = NSClassFromString([resource valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE_BUNDLE_CLASS]);
//                    rscBundle = [NSBundle bundleForClass:bundleClass];
//                }
//
//                if ( rscBundle != nil )
//                {
//                    NSString *localPath = [rscBundle pathForResource:[filename lastPathComponent] ofType:ext inDirectory:subpath];
//                    if ( localPath != nil )
//                    {
//                        [resourceDictionary setObject:localPath forKey:[filename stringByAppendingPathExtension:ext]];
//                        [groupSet addObject:[filename stringByAppendingPathExtension:ext]];
//                    }
//                    else
//                    {
//                        GVCLogError(@"Failed to find resource %@  %@/%@.%@", rscBundle, subpath, filename, ext);
//                    }
//                }
//                else 
//                {
//                    GVCLogError(@"Failed to find class %@ for resource %@.%@", [resource valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE_BUNDLE_CLASS], filename, ext);
//                }
//            }
//        }
//    }
}

- (void)processRemoteResources:(NSDictionary *)propDict
{
//    // no downloads required
//    [self setActiveDownloads:0];
//
//    if ( gvc_IsEmpty(propDict) == NO)
//    {
//        for (NSString *resourceGroup in propDict )
//        {
//            NSArray *group = [propDict valueForKey:resourceGroup];
//            NSMutableSet *groupSet = [resourceGroupDictionary valueForKey:resourceGroup];
//            if ( groupSet == nil )
//            {
//                groupSet = [[NSMutableSet alloc] initWithCapacity:[group count]];
//                [resourceGroupDictionary setObject:groupSet forKey:resourceGroup];
//            }
//            
//            for ( NSDictionary *resource in group)
//            {
//                NSString *remotePath = [resource valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE_PATH];
//                NSString *remoteURL = [resource valueForKey:GVCConfiguration_plist_CONFIG_RESOURCE_URL];
//                if ((gvc_IsEmpty(remoteURL) == YES) && (gvc_IsEmpty(remotePath) == NO))
//                {
//                    remoteURL = GVC_SPRINTF(@"%@/%@", [self baseURL], remotePath);
//                }
//                NSURL *url = [NSURL URLWithString:remoteURL];
//                if ( url != nil )
//                {
//                    // create a local destination path
//                    NSString *filename = [url lastPathComponent];
//                    NSString *cached = [[[GVCDirectory CacheDirectory] createSubdirectory:resourceGroup] fullpathForFile:filename];
//                    NSString *temp = [[GVCDirectory TempDirectory] fullpathForFile:[NSString gvc_StringWithUUID]];
//
//                    GVCNetOperation *rscDownload = [[GVCNetOperation alloc] initForURL:url];
//                    [rscDownload setResponseData:[[GVCStreamResponseData alloc] initForFilename:temp]];
//                    [rscDownload setDidFinishBlock:^(GVCOperation *operation) {
//                        
//                        NSFileManager *fileMgr = [NSFileManager defaultManager];
//                        NSString *newFileHash = [fileMgr gvc_md5Hash:temp];
//                        if (([fileMgr fileExistsAtPath:cached] == NO) || ([fileMgr gvc_validateFile:cached withMD5Hash:newFileHash] == NO))
//                        {
//                            GVCLogError(@"cached %@", cached);
//                            NSError *mvErr = nil;
//                            if ([fileMgr moveItemAtPath:temp toPath:cached error:&mvErr] == YES )
//                            {
//                                // success !
//                                [resourceDictionary setObject:cached forKey:filename];
//                                [groupSet addObject:filename];
//                            }
//                            else
//                            {
//                                GVCLogError(@"Move file error %@", mvErr);
//                            }
//                        }
//                        else
//                        {
//                            GVCLogError(@"Finalpath %@ hashes match %@", cached, newFileHash);
//                        }
//                    }];
//                    
//                    [rscDownload setDidStartBlock:^(GVCOperation *operation) {
//                        [self increaseActiveDownloads];
//                    }];
//                    [rscDownload setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
//                        GVCLogError(@"Operation Failed %@", err);
//                        [self decreaseActiveDownloads];
//                    }];
//                    [[self operationQueue] addOperation:rscDownload];
//                }
//            }
//        }
//    }
}

@end
