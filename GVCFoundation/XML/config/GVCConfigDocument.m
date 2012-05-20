/*
 * GVCConfigDocument.m
 * 
 * Created by David Aspinall on 12-05-17. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCConfigDocument.h"
#import "GVCFunctions.h"
#import "GVCMacros.h"
#import "GVCXMLGenerator.h"
#import "GVCStringWriter.h"

#import "GVCConfigPackage.h"


@interface GVCConfigDocument ()
@property (strong, nonatomic) NSMutableDictionary *packageByName;
@end

@implementation GVCConfigDocument

@synthesize version;
@synthesize md5;
@synthesize packageByName;

@synthesize sharedPackage;

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
	}
	
    return self;
}

- (NSArray *)packageNames
{
    return [[self packageByName] allKeys];
}

- (NSArray *)allPackages
{
    return [[self packageByName] allValues];
}

- (void)addPackage:(GVCConfigPackage *)package
{
    GVC_ASSERT_NOT_NIL(package);
    GVC_ASSERT_NOT_NIL([package name]);
    
    if ( [self packageByName] == nil ) 
    {
        [self setPackageByName:[[NSMutableDictionary alloc] initWithCapacity:1]];
    }
    [[self packageByName] setObject:package forKey:[package name]];
}

- (GVCConfigPackage *)packageForName:(NSString *)pkg;
{
    GVC_ASSERT_NOT_NIL(pkg);
    
    return (GVCConfigPackage *)[[self packageByName] objectForKey:pkg];
}

- (void)removePackageForName:(NSString *)pkg;
{
    GVC_ASSERT_NOT_NIL(pkg);
    [[self packageByName] removeObjectForKey:pkg];
}

- (NSString *)description
{
    GVCStringWriter *writer = [[GVCStringWriter alloc] init];
    GVCXMLGenerator *gen = [[GVCXMLGenerator alloc] initWithWriter:writer andFormat:GVC_XML_GeneratorFormat_PRETTY];
    [self writeConfiguration:gen];
    return [writer string];
}

- (void)writeConfiguration:(GVCXMLGenerator *)outputGenerator
{
	NSMutableDictionary *copyDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    if ( gvc_IsEmpty([self md5]) == NO )
    {
        [copyDict setObject:[self md5] forKey:@"md5"];
    }
    if ( gvc_IsEmpty([self version]) == NO )
    {
        [copyDict setObject:[self version] forKey:@"version"];
    }
    
    [outputGenerator openElement:@"config" inNamespace:nil withAttributes:copyDict];
    if ( [self sharedPackage] != nil )
        [[self sharedPackage] writeConfiguration:outputGenerator];
    
    for (GVCConfigPackage *pkg in [[self packageByName] allValues])
    {
        [pkg writeConfiguration:outputGenerator];
    }
    [outputGenerator closeElement]; // config
}


@end
