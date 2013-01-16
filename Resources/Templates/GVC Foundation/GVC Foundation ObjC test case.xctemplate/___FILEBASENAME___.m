/*
 * ___FILENAME___
 * 
 * Created by ___FULLUSERNAME___ on ___DATE___. 
 * Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
 *
 */

#import <SenTestingKit/SenTestingKit.h>
#import <GVCFoundation/GVCFoundation.h>

#pragma mark - Interface declaration
@interface ___FILEBASENAMEASIDENTIFIER___ : SenTestCase

@end


#pragma mark - Test Case implementation
@implementation ___FILEBASENAMEASIDENTIFIER___

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
- (void)testMath
{
    STAssertTrue((1 + 1) == 2, @"Compiler isn't feeling well today :-(");
}

@end
