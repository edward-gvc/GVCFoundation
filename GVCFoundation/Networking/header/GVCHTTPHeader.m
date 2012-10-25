/*
 * GVCHTTPHeader.m
 * 
 * Created by David Aspinall on 12-05-13. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCHTTPHeader.h"
#import "GVCFunctions.h"
#import "GVCLogger.h"
#import "NSString+GVCFoundation.h"

@interface GVCHTTPHeader ()
@property (strong, nonatomic) NSMutableDictionary *parameterDictionary;
@end

@implementation GVCHTTPHeader

@synthesize parameterDictionary;
@synthesize headerName;
@synthesize headerValue;

- (id)init
{
    return [self initForHeaderName:nil andValue:nil];
}

- (id)initForHeaderName:(NSString *)aName
{
    return [self initForHeaderName:aName andValue:nil];
}

- (id)initForHeaderName:(NSString *)aName andValue:(NSString *)value
{
	self = [super init];
	if ( self != nil )
	{
        [self setHeaderName:aName];
        [self setHeaderValue:value];
	}
	
    return self;
}

#pragma mark - Parameters
- (NSDictionary *)parameters
{
    return (gvc_IsEmpty([self parameterDictionary]) == YES ? nil : [[self parameterDictionary] copy]);
}

- (void)addParameter:(NSString *)paramName withValue:(NSString *)paramValue
{
    GVC_ASSERT_NOT_EMPTY(paramName);
    
    if ( [self parameterDictionary] == nil )
    {
        [self setParameterDictionary:[[NSMutableDictionary alloc] initWithCapacity:10]];
    }
    
    if ( paramValue == nil )
    {
        paramValue = [NSString gvc_EmptyString];
    }
    [[self parameterDictionary] setValue:paramValue forKey:[paramName lowercaseString]];
}

- (NSString *)parameterForKey:(NSString *)paramName
{
    return (gvc_IsEmpty([self parameterDictionary]) == YES ? nil : [[self parameterDictionary] valueForKey:paramName]);
}

- (NSString *)description
{
    return GVC_SPRINTF(@"%@ %@=%@ parameters %@", [super description], [self headerName], [self headerValue], [self parameterDictionary] );
}


@end
