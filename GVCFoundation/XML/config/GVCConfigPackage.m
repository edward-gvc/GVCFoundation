/*
 * GVCConfigPackage.m
 * 
 * Created by David Aspinall on 12-05-17. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCConfigPackage.h"
#import "GVCFunctions.h"
#import "GVCMacros.h"
#import "GVCXMLGenerator.h"

#import "GVCConfigProperty.h"
#import "GVCConfigResource.h"

@interface GVCConfigPackage ()
@property (strong, nonatomic) NSMutableArray *properties;
@property (strong, nonatomic) NSMutableDictionary *resourcesByName;
@property (strong, nonatomic) NSMutableDictionary *resourcesByTag;
@end


@implementation GVCConfigPackage

@synthesize name;
@synthesize status;
@synthesize properties;
@synthesize resourcesByName;
@synthesize resourcesByTag;

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
	}
	
    return self;
}

- (NSArray *)allProperties
{
    return [self properties];
}

- (void)addProperty:(GVCConfigProperty *)prop
{
    GVC_ASSERT_NOT_NIL(prop);
    
    if ([self allProperties] == nil )
    {
        [self setProperties:[[NSMutableArray alloc] initWithCapacity:1]];
    }
    
    [[self properties] addObject:prop];
}

- (void)addResource:(GVCConfigResource *)resource
{
    GVC_ASSERT_NOT_NIL(resource);
    GVC_ASSERT_NOT_NIL([resource name]);
    
    if ( gvc_IsEmpty([resource tag]) == NO )
    {
        if ( [self resourcesByTag] == nil )
        {
            [self setResourcesByTag:[[NSMutableDictionary alloc] initWithCapacity:1]];
        }
        
        if ( [[self resourcesByTag] objectForKey:[resource tag]] == nil )
        {
            [[self resourcesByTag] setObject:[[NSMutableArray alloc] initWithCapacity:1] forKey:[resource tag]];
        }
        
        [(NSMutableArray *)[[self resourcesByTag] objectForKey:[resource tag]] addObject:resource];
    }
    
    if ( [self resourcesByName] == nil )
    {
        [self setResourcesByName:[[NSMutableDictionary alloc] initWithCapacity:1]];
    }
    
    [[self resourcesByName] setObject:resource forKey:[resource name]];

}

- (GVCConfigResource *)resourceForName:(NSString *)rsc
{
    return [[self resourcesByName] objectForKey:rsc];
}

- (NSArray *)resourcesForTag:(NSString *)tag
{
    return [[self resourcesByTag] objectForKey:tag];
}

- (void)writeConfiguration:(GVCXMLGenerator *)outputGenerator
{
	NSMutableDictionary *copyDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [copyDict setObject:[self name] forKey:@"name"];
    if ( gvc_IsEmpty([self status]) == NO )
    {
        [copyDict setObject:[self status] forKey:@"status"];
    }
    
    [outputGenerator openElement:@"package" inNamespace:nil withAttributes:copyDict];
    for (GVCConfigProperty *prop in [self properties])
    {
        [prop writeConfiguration:outputGenerator];
    }
    
    NSArray *rscArray = [[self resourcesByName] allValues];
    for ( GVCConfigResource *rsc in rscArray )
    {
        [rsc writeConfiguration:outputGenerator];
    }
    [outputGenerator closeElement]; // package
}

@end


@implementation GVCConfigSharedPackage

- (void)writeConfiguration:(GVCXMLGenerator *)outputGenerator
{
	NSMutableDictionary *copyDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    if ( gvc_IsEmpty([self status]) == NO )
    {
        [copyDict setObject:[self status] forKey:@"status"];
    }
    
    [outputGenerator openElement:@"shared" inNamespace:nil withAttributes:copyDict];
    for (GVCConfigProperty *prop in [self properties])
    {
        [prop writeConfiguration:outputGenerator];
    }
    
    NSArray *rscArray = [[self resourcesByName] allValues];
    for ( GVCConfigResource *rsc in rscArray )
    {
        [rsc writeConfiguration:outputGenerator];
    }
    [outputGenerator closeElement]; // shared
}

@end

