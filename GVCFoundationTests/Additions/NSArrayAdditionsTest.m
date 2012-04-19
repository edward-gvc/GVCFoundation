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

@property (strong, nonatomic) NSArray *alphaArray;
@property (strong, nonatomic) NSArray *numberArray;
@property (strong, nonatomic) NSArray *randomishArray;

@end


#pragma mark - Test Case implementation
@implementation NSArrayAdditionsTest

@synthesize alphaArray;
@synthesize numberArray;
@synthesize randomishArray;

	// setup for all the following tests
- (void)setUp
{
    [super setUp];
    [self setAlphaArray:[NSArray arrayWithObjects:@"a", @"aaa", @"bbb", @"cc", @"ddd", @"eae", nil]];
    [self setNumberArray:[NSArray arrayWithObjects:@"11", @"22", @"33", @"44", @"55", @"66", nil]];
    [self setRandomishArray:[NSArray arrayWithObjects:@"a", @"bbb", @"ddd", @"aaa", @"eae", @"cc", nil]];
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

- (void)testgvc_performOnEach
{
    __block NSInteger total = 0;
    GVCNSArrayEachBlock each = ^(id item) {
        total += [(NSString *)item length];
    };
    [[self alphaArray] gvc_performOnEach:each];
	STAssertTrue(total == 15, @"Total length expected was 15, result was %d", total );
}


- (void)testgvc_filterArrayForAccept
{
    GVCNSArrayAcceptBlock each = ^(id item) {
        NSRange range = [(NSString *)item rangeOfString:@"a"];
        return (BOOL)(range.length == 1);
    };
    NSArray *filtered = [[self alphaArray] gvc_filterArrayForAccept:each];
    NSArray *expected = [NSArray arrayWithObjects:@"a", @"aaa", @"eae", nil];

	STAssertTrue(gcv_IsEqualCollection( expected, filtered), @"'%@' != filterd '%@'", expected, filtered );
}

- (void)testgvc_filterArrayForRejects
{
    GVCNSArrayAcceptBlock each = ^(id item) {
        NSRange range = [(NSString *)item rangeOfString:@"a"];
        return (BOOL)(range.length == 1);
    };
    NSArray *filtered = [[self alphaArray] gvc_filterArrayForReject:each];
    NSArray *expected = [NSArray arrayWithObjects:@"bbb", @"cc", @"ddd", nil];
    
	STAssertTrue(gcv_IsEqualCollection( expected, filtered), @"'%@' != filterd '%@'", expected, filtered );
}

- (void)testgvc_filterArrayFor
{
    GVCNSArrayResultBlock each = ^(id item) {
        NSNumber *num = [NSNumber numberWithInteger:[item intValue]];
        return num;
    };
    NSArray *filtered = [[self numberArray] gvc_resultArray:each];
    NSArray *expected = [NSArray arrayWithObjects:[NSNumber numberWithInteger:11], 
                         [NSNumber numberWithInteger:22], 
                         [NSNumber numberWithInteger:33], 
                         [NSNumber numberWithInteger:44], 
                         [NSNumber numberWithInteger:55], 
                         [NSNumber numberWithInteger:66], nil];
    
	STAssertTrue(gcv_IsEqualCollection( expected, filtered), @"'%@' != filterd '%@'", expected, filtered );
}

@end
