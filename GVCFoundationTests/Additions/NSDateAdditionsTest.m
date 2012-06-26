/*
 * NSDateAdditionsTest.m
 * 
 * Created by David Aspinall on 12-06-26. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <SenTestingKit/SenTestingKit.h>
#import "GVCFoundation.h"

#pragma mark - Interface declaration
@interface NSDateAdditionsTest : SenTestCase

@end


#pragma mark - Test Case implementation
@implementation NSDateAdditionsTest

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
- (void)testISOLongParser
{
	NSString *iso_1 = @"2012-06-26T07:37:05Z";
	NSDate *date_1 = [NSDate gvc_DateFromISO8601:iso_1];
	STAssertNotNil(date_1, @"Failed to parse date %@", iso_1);

}


@end
