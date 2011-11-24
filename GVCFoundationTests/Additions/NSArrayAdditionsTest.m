/*
 * NSArrayAdditionsTest.m
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import <SenTestingKit/SenTestingKit.h>
#import "GVCFoundation.h"

#pragma mark - Interface declaration
@interface NSArrayAdditionsTest : SenTestCase

@end


#pragma mark - Test Case implementation
@implementation NSArrayAdditionsTest

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
- (void)testgvc_ArrayByOrderingSet_byKey_ascending
{
	NSMutableSet *set = [[NSMutableSet alloc] initWithObjects:@"AAA", @"BBBB", @"CC", @"D", nil];
	NSArray *unsorted = [set allObjects];
	NSArray *expectedByLength = [NSArray arrayWithObjects:@"D", @"CC", @"AAA", @"BBBB", nil];
	
		// sort the array using the string length selector
	NSArray *sorted = [NSArray gvc_ArrayByOrderingSet:set byKey:@"length" ascending:YES];
	STAssertFalse(gcv_IsEqualCollection( unsorted, sorted), @"'%@' != sorted '%@'", unsorted, sorted );
	STAssertTrue(gcv_IsEqualCollection( expectedByLength, sorted), @"'%@' != sorted '%@'", expectedByLength, sorted );

}

@end
