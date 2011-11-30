/*
 * GVCLogTest.m
 * 
 * Created by David Aspinall on 11-11-29. 
 * Copyright (c) 2011 Global Village Consulting. All rights reserved.
 *
 */

#import <SenTestingKit/SenTestingKit.h>
#import "GVCFoundation.h"

#pragma mark - Interface declaration
@interface GVCLogTest : SenTestCase

@end


#pragma mark - Test Case implementation
@implementation GVCLogTest

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

- (void)testLogLevels
{
    GVCLogError(@"Test Log message");
    
    GVCLogger *logger = [GVCLogger sharedGVCLogger];
//    GVCLoggerLevel current = [logger loggerLevel];
    NSLog(@"%@", logger);
}

	// All code under test must be linked into the Unit Test bundle
- (void)testMessage
{
    GVCLogMessage *msg = [[GVCLogMessage alloc] initLevel:GVCLoggerLevel_INFO file:__FILE__ function:__FUNCTION__ line:__LINE__ message:@"Test Message"];
    
    NSLog(@"%@", msg);
}

@end
