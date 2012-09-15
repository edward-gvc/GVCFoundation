/*
 * GVCRSSDigestTest.m
 * 
 * Created by David Aspinall on 12-03-14. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <SenTestingKit/SenTestingKit.h>

#import "GVCFoundation.h"
#import "GVCResourceTestCase.h"

#pragma mark - Interface declaration
@interface GVCRSSDigestTest : GVCResourceTestCase

@end


#pragma mark - Test Case implementation
@implementation GVCRSSDigestTest

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

- (GVCRSSFeed *)feedFromFile:(NSString *)file forNode:(NSString *)root
{
	//[[GVCLogger sharedGVCLogger] setLoggerLevel:GVCLoggerLevel_INFO];
	
	GVCRSSDigester *parser = [[GVCRSSDigester alloc] init];
	[parser setFilename:[self pathForResource:file extension:@"xml"]];
	GVCXMLParserDelegate_Status stat = [parser parse];
	STAssertTrue(stat == GVCXMLParserDelegate_Status_SUCCESS, @"%@ Parse status = %d", file, stat);
	
	GVCRSSFeed *feed = [parser digestValueForPath:root];
	GVCFileWriter *writer = [GVCFileWriter writerForFilename:GVC_SPRINTF(@"/tmp/%@.rss", file)];
	GVCXMLGenerator *outgen = [[GVCXMLGenerator alloc] initWithWriter:writer andFormat:GVC_XML_GeneratorFormat_PRETTY];
	[feed writeRss:outgen];
	
	return feed;
}
	// All code under test must be linked into the Unit Test bundle
- (void)testDaringFireBall
{
	GVCRSSFeed *feed = [self feedFromFile:@"DaringFireball" forNode:@"feed"];
	GVCLogError(@"Digest %@", feed);
}

// All code under test must be linked into the Unit Test bundle
- (void)testRSS2
{
	GVCRSSFeed *feed = [self feedFromFile:@"sample-rss-2" forNode:@"rss"];
	GVCLogError(@"Digest %@", feed);
}

// All code under test must be linked into the Unit Test bundle
- (void)testiTunesRSS
{
	GVCRSSFeed *feed = [self feedFromFile:@"itunesTop300" forNode:@"rss"];
	GVCLogError(@"Digest %@", feed);
}

@end
