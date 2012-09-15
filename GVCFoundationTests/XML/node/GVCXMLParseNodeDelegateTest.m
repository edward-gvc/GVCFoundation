/*
 * GVCXMLParseNodeDelegateTest.m
 * 
 * Created by David Aspinall on 12-03-09. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <SenTestingKit/SenTestingKit.h>
#import "GVCFoundation.h"
#import "GVCResourceTestCase.h"

#pragma mark - Interface declaration
@interface GVCXMLParseNodeDelegateTest : GVCResourceTestCase

@end


#pragma mark - Test Case implementation
@implementation GVCXMLParseNodeDelegateTest

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
- (void)testParse
{
	[[GVCLogger sharedGVCLogger] setLoggerLevel:GVCLoggerLevel_INFO];

	GVCXMLParseNodeDelegate *parser = [[GVCXMLParseNodeDelegate alloc] init];
	[parser setFilename:[self pathForResource:XML_Agent_OIDs extension:@"xml"]];
	GVCXMLParserDelegate_Status stat = [parser parse];
	STAssertTrue(stat == GVCXMLParserDelegate_Status_SUCCESS, @"Parse status = %d", stat);
	
	GVCXMLDocument *doc = [parser document];
	GVCLogError(@"Document %@", doc);
}

@end
