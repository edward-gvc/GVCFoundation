/*
 * GVCDirectoryTest.m
 * 
 * Created by David Aspinall on 11-12-06. 
 * Copyright (c) 2011 Global Village Consulting. All rights reserved.
 *
 */

#import <SenTestingKit/SenTestingKit.h>
#import "GVCFoundation.h"

#pragma mark - Interface declaration
@interface GVCDirectoryTest : SenTestCase

@end


#pragma mark - Test Case implementation
@implementation GVCDirectoryTest

	// setup for all the following tests
- (void)setUp
{
    [super setUp];
}

	// tear down the test setup
- (void)tearDown
{
    [super tearDown];
}

	// All code under test must be linked into the Unit Test bundle
- (void)testTemporaryDir
{
    GVCDirectory *temp1 = [GVCDirectory TempDirectory];
    GVCDirectory *temp2 = [GVCDirectory TempDirectory];
    
    STAssertNotNil(temp1, @"Temporary directory first call is nil" );
    STAssertNotNil(temp2, @"Temporary directory second call is nil" );
    STAssertEqualObjects(temp1, temp2, @"Should act like a singleton %@ != %@", temp1, temp2);
    STAssertEqualObjects([temp1 rootDirectory], [temp2 rootDirectory], @"Should be same path %@ != %@", [temp1 rootDirectory], [temp2 rootDirectory]);
    
    GVCLogError(@"Temp: %@", [temp1 rootDirectory]);
}

// All code under test must be linked into the Unit Test bundle
- (void)testCacheDir
{
    GVCDirectory *cache1 = [GVCDirectory CacheDirectory];
    GVCDirectory *cache2 = [GVCDirectory CacheDirectory];
    
    STAssertNotNil(cache1, @"Cache directory first call is nil" );
    STAssertNotNil(cache2, @"Cache directory second call is nil" );
    STAssertEqualObjects(cache1, cache2, @"Should act like a singleton %@ != %@", cache1, cache2);
    STAssertEqualObjects([cache1 rootDirectory], [cache2 rootDirectory], @"Should be same path %@ != %@", [cache1 rootDirectory], [cache2 rootDirectory]);
    
    GVCLogError(@"cache: %@", [cache1 rootDirectory]);
}

@end
