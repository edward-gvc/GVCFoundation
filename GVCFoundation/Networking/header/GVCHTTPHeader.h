/*
 * GVCHTTPHeader.h
 * 
 * Created by David Aspinall on 12-05-13. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@interface GVCHTTPHeader : NSObject

- (id)initForHeaderName:(NSString *)aName;
- (id)initForHeaderName:(NSString *)aName andValue:(NSString *)value;

@property (strong, nonatomic) NSString *headerName;
@property (strong, nonatomic) NSString *headerValue;

- (NSDictionary *)parameters;
- (void)addParameter:(NSString *)paramName withValue:(NSString *)paramValue;
- (NSString *)parameterForKey:(NSString *)paramName;

@end
