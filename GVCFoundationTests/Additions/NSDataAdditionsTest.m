/*
 * NSDataAdditionsTest.m
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import <SenTestingKit/SenTestingKit.h>
#import <GVCFoundation/GVCFoundation.h>

#pragma mark - Interface declaration
@interface NSDataAdditionsTest : SenTestCase

@end


#pragma mark - Test Case implementation
@implementation NSDataAdditionsTest

	// setup for all the following tests
- (void)setUp
{
    [super setUp];
	// seed random from /dev/random
	srandomdev();
}

	// tear down the test setup
- (void)tearDown
{
    [super tearDown];
}

	// All code under test must be linked into the Unit Test bundle
- (void)testBase64
{
	for (NSUInteger x = 1 ; x < 1024 ; ++x)
	{
		NSMutableData *data = [[NSMutableData alloc] initWithCapacity:x];
		STAssertNotNil(data, @"failed to alloc data block");

		//		void *buf = [data mutableBytes];

		Byte buf[1];
		for (NSUInteger idx = 0 ; idx < x ; idx++)
		{
			buf[0] = random() & 0xFF;
			[data appendBytes:&buf length:1];
		}
				
		NSString *encoded = [data gvc_base64Encoded];
		STAssertNotNil(encoded, @"Failed to encode base 64");
		STAssertEquals(([encoded length] % 4), (NSUInteger)0, @"encoded size should be a multiple of 4");
		
		NSData *decoded = [NSData gvc_Base64Decoded:encoded];
		STAssertNotNil(decoded, @"Failed to decode base 64");
		STAssertEqualObjects(data, decoded, @"Decode failed");
	}
}

- (void)testBoundsBase64
{
	NSString *encoded = nil;
	NSData *decoded = nil;
	NSString *correctRaw = nil;
	NSString *correctEncoding = nil;
	
	// empty data
	NSData *emptyData = [NSData data];
	encoded = [emptyData gvc_base64Encoded];
	STAssertEquals(([encoded length] % 4), (NSUInteger)0, @"encoded size should be a multiple of 4");
	STAssertEquals([encoded length], (NSUInteger)0, @"encoded size of empty data should be 0");

	// one input char
	correctRaw = @"A";
	correctEncoding = @"QQ==";
	NSData *oneCharData = [correctRaw dataUsingEncoding:NSUTF8StringEncoding];
	encoded = [oneCharData gvc_base64Encoded];
	STAssertEquals(([encoded length] % 4), (NSUInteger)0, @"encoded size should be a multiple of 4");
	STAssertEqualObjects(encoded, correctEncoding, @"encoded '%@' should equal '%@'", encoded, correctEncoding);

	decoded = [NSData gvc_Base64Decoded:encoded];
	STAssertNotNil(decoded, @"Faild to decode");
	STAssertEqualObjects(oneCharData, decoded, @"Decode failed for '%@'", correctRaw);

	// two input char
	correctRaw = @"AB";
	correctEncoding = @"QUI=";
	NSData *twoCharData = [correctRaw dataUsingEncoding:NSUTF8StringEncoding];
	encoded = [twoCharData gvc_base64Encoded];
	STAssertEquals(([encoded length] % 4), (NSUInteger)0, @"encoded size should be a multiple of 4");
	STAssertEqualObjects(encoded, correctEncoding, @"encoded '%@' should equal '%@'", encoded, correctEncoding);
	
	decoded = [NSData gvc_Base64Decoded:encoded];
	STAssertEqualObjects(twoCharData, decoded, @"Decode failed for '%@'", correctRaw);

	// three input char
	correctRaw = @"ABC";
	correctEncoding = @"QUJD";
	NSData *threeCharData = [correctRaw dataUsingEncoding:NSUTF8StringEncoding];
	encoded = [threeCharData gvc_base64Encoded];
	STAssertEquals(([encoded length] % 4), (NSUInteger)0, @"encoded size should be a multiple of 4");
	STAssertEqualObjects(encoded, correctEncoding, @"encoded '%@' should equal '%@'", encoded, correctEncoding);
	
	decoded = [NSData gvc_Base64Decoded:encoded];
	STAssertEqualObjects(threeCharData, decoded, @"Decode failed for '%@'", correctRaw);

	// four input char
	correctRaw = @"ABCD";
	correctEncoding = @"QUJDRA==";
	NSData *fourCharData = [correctRaw dataUsingEncoding:NSUTF8StringEncoding];
	encoded = [fourCharData gvc_base64Encoded];
	STAssertEquals(([encoded length] % 4), (NSUInteger)0, @"encoded size should be a multiple of 4");
	STAssertEqualObjects(encoded, correctEncoding, @"encoded '%@' should equal '%@'", encoded, correctEncoding);
	
	decoded = [NSData gvc_Base64Decoded:encoded];
	STAssertEqualObjects(fourCharData, decoded, @"Decode failed for '%@'", correctRaw);

	// all char from 0 to ff.
	/*
	 NSData 256 bytes :
	 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F | ................
	 10 11 12 13 14 15 16 17 18 19 1A 1B 1C 1D 1E 1F | ................
	 20 21 22 23 24 25 26 27 28 29 2A 2B 2C 2D 2E 2F |  !"#$%&'()*+,-./
	 30 31 32 33 34 35 36 37 38 39 3A 3B 3C 3D 3E 3F | 0123456789:;<=>?
	 40 41 42 43 44 45 46 47 48 49 4A 4B 4C 4D 4E 4F | @ABCDEFGHIJKLMNO
	 50 51 52 53 54 55 56 57 58 59 5A 5B 5C 5D 5E 5F | PQRSTUVWXYZ[\]^_
	 60 61 62 63 64 65 66 67 68 69 6A 6B 6C 6D 6E 6F | `abcdefghijklmno
	 70 71 72 73 74 75 76 77 78 79 7A 7B 7C 7D 7E 7F | pqrstuvwxyz{|}~
	 80 81 82 83 84 85 86 87 88 89 8A 8B 8C 8D 8E 8F | ................
	 90 91 92 93 94 95 96 97 98 99 9A 9B 9C 9D 9E 9F | ................
	 A0 A1 A2 A3 A4 A5 A6 A7 A8 A9 AA AB AC AD AE AF | ................
	 B0 B1 B2 B3 B4 B5 B6 B7 B8 B9 BA BB BC BD BE BF | ................
	 C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 CA CB CC CD CE CF | ................
	 D0 D1 D2 D3 D4 D5 D6 D7 D8 D9 DA DB DC DD DE DF | ................
	 E0 E1 E2 E3 E4 E5 E6 E7 E8 E9 EA EB EC ED EE EF | ................
	 F0 F1 F2 F3 F4 F5 F6 F7 F8 F9 FA FB FC FD FE FF | ................
	 */
	NSMutableData *rawData = [[NSMutableData alloc] initWithCapacity:256];
	STAssertNotNil(rawData, @"failed to alloc data block");
	Byte buf[1];
	for (NSUInteger idx = 0 ; idx < 256 ; idx++)
	{
		buf[0] = idx & 0xFF;
		[rawData appendBytes:&buf length:1];
	}
	correctEncoding = @"AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJygpKissLS4vMDEyMzQ1Njc4OTo7PD0+P0BBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWltcXV5fYGFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6e3x9fn+AgYKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqbnJ2en6ChoqOkpaanqKmqq6ytrq+wsbKztLW2t7i5uru8vb6/wMHCw8TFxsfIycrLzM3Oz9DR0tPU1dbX2Nna29zd3t/g4eLj5OXm5+jp6uvs7e7v8PHy8/T19vf4+fr7/P3+/w==";

	encoded = [rawData gvc_base64Encoded];
	STAssertEquals(([encoded length] % 4), (NSUInteger)0, @"encoded size should be a multiple of 4");
	STAssertEqualObjects(encoded, correctEncoding, @"encoded should equal correct encoding");
	
	decoded = [NSData gvc_Base64Decoded:encoded];
	STAssertEqualObjects(rawData, decoded, @"Decode failed all char 256");
}
@end
