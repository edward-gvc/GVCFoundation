/*
 * GVCISO8601DateFormatterTest.m
 * 
 * Created by David Aspinall on 12-03-08. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <SenTestingKit/SenTestingKit.h>
#import "GVCFoundation.h"

#pragma mark - Interface declaration
@interface GVCISO8601DateFormatterTest : SenTestCase
@property (strong, nonatomic) NSDate *currentDate;
@property (strong, nonatomic) NSDate *pastDate;
@property (strong, nonatomic) NSDate *futureDate;

@property (strong, nonatomic) NSString *currentString;
@property (strong, nonatomic) NSString *pastString;
@property (strong, nonatomic) NSString *futureString;
@end


#pragma mark - Test Case implementation
@implementation GVCISO8601DateFormatterTest
@synthesize currentDate;
@synthesize pastDate;
@synthesize futureDate;

@synthesize currentString;
@synthesize pastString;
@synthesize futureString;


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
- (void)testCalendarFormat
{
	GVCISO8601DateFormatter *formatter = [[GVCISO8601DateFormatter alloc] init];
	[formatter setFormat:GVCISO8601DateFormatter_Calendar];
	
	NSDate *today = [NSDate date];
	GVCLogError(@"%@ = %@", today, [formatter stringFromDate:today]);
}

- (void)testFullParse
{
	GVCISO8601DateFormatter *formatter = [[GVCISO8601DateFormatter alloc] init];
	[formatter setFormat:GVCISO8601DateFormatter_Calendar];
	NSString *iso_1 = @"2012-06-26T07:37:05Z";
	NSDate *date_1 = [formatter dateFromString:iso_1];
	STAssertNotNil(date_1, @"Failed to parse date %@", date_1);
}

@end
