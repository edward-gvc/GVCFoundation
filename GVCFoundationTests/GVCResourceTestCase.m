/*
 * GVCResourceTestCase.m
 * 
 * Created by David Aspinall on 12-03-08. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCResourceTestCase.h"

GVC_DEFINE_STRVALUE(CSV_Cars, Cars)
GVC_DEFINE_STRVALUE(CSV_VocabularySummary, Vocabulary Summary)

GVC_DEFINE_STRVALUE(XML_Agent_Digest, AgentDigest)

GVC_DEFINE_STRVALUE(XML_Agent_OIDs, Agent_OIDs)
GVC_DEFINE_STRVALUE(XML_addImmunization_request, addImmunization_request)
GVC_DEFINE_STRVALUE(XML_addImmunization_response, addImmunization_response)
GVC_DEFINE_STRVALUE(XML_patientProfile_request, patientProfile_request)
GVC_DEFINE_STRVALUE(XML_patientProfile_response, patientProfile_response)
GVC_DEFINE_STRVALUE(XML_sample_soap, sample_soap)

@implementation GVCResourceTestCase

- (void)setUp
{
    [super setUp];
}

// tear down the test setup
- (void)tearDown
{
    [super tearDown];
}

- (NSString *)pathForResource:(NSString *)name extension:(NSString *)ext
{
	STAssertNotNil(name, @"Resource name cannot be nil");
	STAssertNotNil(ext, @"Resource extension cannot be nil");
	
	NSString *file = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:ext];
	
	STAssertNotNil(file, @"Unable to locate %@.%@ file", name, ext);
	STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:file], @"File does not exist %@", file);
	
	return file;
}

@end
