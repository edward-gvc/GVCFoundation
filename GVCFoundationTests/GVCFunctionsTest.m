/*
 * GVCFunctionsTest.m
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import <SenTestingKit/SenTestingKit.h>
#import "GVCFoundation.h"

#pragma mark - Interface declaration
@interface GVCFunctionsTest : SenTestCase

@end


#pragma mark - Test Case implementation
@implementation GVCFunctionsTest

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

- (void)testIsEmptyClass
{
	NSString *testStr = nil;
	
	STAssertTrue(gvc_IsEmpty(testStr), @"nil string should be detected as IsEmpty = true");
	
	testStr = [NSString gvc_EmptyString];
	STAssertTrue(gvc_IsEmpty(testStr), @"Empty string should be detected as IsEmpty = true");
	
	testStr = @"NotEmpty";
	STAssertFalse(gvc_IsEmpty(testStr), @"String should be detected as '%@'", testStr);
}

- (void)testgcv_IsEqualCollection
{
	NSArray *arrayA = [NSArray arrayWithObjects:@"D", @"CC", @"AAA", @"DDDD", nil];
	NSArray *arrayB = [NSArray arrayWithObjects:@"D", @"CC", @"AAA", @"DDDD", nil];
	NSArray *arrayC = [NSArray arrayWithObjects:@"D", @"CC", @"XXX", @"DDDD", nil];

	STAssertTrue(gcv_IsEqualCollection(arrayA, arrayB), @"Arrays should be equal %@ != %@", arrayA, arrayB);
	STAssertFalse(gcv_IsEqualCollection(arrayA, arrayC), @"Arrays should not be equal %@ != %@", arrayA, arrayC);
	
}
@end
