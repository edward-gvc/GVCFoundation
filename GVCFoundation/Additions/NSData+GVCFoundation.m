/*
 * NSData+GVCFoundation.m
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import "NSData+GVCFoundation.h"
#import "NSString+GVCFoundation.h"
#import "GVCFunctions.h"

#import <CommonCrypto/CommonDigest.h>

const NSUInteger kDefaultMaxBytesToHexDump = 1024;

@implementation NSData (GVCFoundation)

static char gvc_b64encodingTable[64] = {
	'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
	'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
	'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
	'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/'
};

static char *gvc_b64decodingTable = NULL;

static void gvc_initialize_b64decodingTable()
{
    static dispatch_once_t b64decodeMutex; \
	dispatch_once(&b64decodeMutex, ^{ \
		gvc_b64decodingTable = malloc(256);
		if (gvc_b64decodingTable != NULL)
			return;
		memset(gvc_b64decodingTable, CHAR_MAX, 256);
		for (NSUInteger i = 0; i < 64; i++)
        {
			gvc_b64decodingTable[(short)gvc_b64encodingTable[i]] = i;
        }
	});
}

static void gvc_b64decodeBlock(unsigned char inbytes[4], unsigned char outbytes[3])
{
    outbytes[0] = (unsigned char)((inbytes[0] << 2) | (inbytes[1] >> 4));
    outbytes[1] = (unsigned char)((inbytes[1] << 4) | (inbytes[2] >> 2));
    outbytes[2] = (unsigned char)(((inbytes[2] << 6) & 0xc0) | inbytes[3]);
    return;
}

- (NSString *)description
{
	return [self gvc_descriptionFromOffset:0];
}

- (NSString *)gvc_descriptionFromOffset:(NSInteger)startOffset
{
	return [self gvc_descriptionFromOffset:startOffset limitingToByteCount:kDefaultMaxBytesToHexDump];
}

- (NSString *)gvc_descriptionFromOffset:(NSInteger)startOffset limitingToByteCount:(NSUInteger)maxBytes
{
    unsigned char *bytes = (unsigned char *)[self bytes];
    NSUInteger stopOffset = [self length];
	NSUInteger adjustedStartOffset = 0;
	
	if ( startOffset < 0 )
	{
		// Translate negative offset to positive, by subtracting from end
		NSInteger length = (NSInteger)[self length];
		startOffset = length - ABS(startOffset);
		if ( startOffset > 0 )
			adjustedStartOffset = (NSUInteger)startOffset;
	}
	else
	{
		adjustedStartOffset = (NSUInteger)startOffset;
	}
	
	NSInteger bytesRequested = (NSInteger)(stopOffset - adjustedStartOffset);
	if (bytesRequested > (NSInteger)maxBytes)
	{
		// Do we have more data than the caller wants?
		stopOffset = adjustedStartOffset + maxBytes;
	}
	
		// If we're showing a subset, we'll tack in info about that
	NSString* curtailInfo = [NSString gvc_EmptyString];
	if ((adjustedStartOffset > 0) || (stopOffset < [self length]))
	{
		curtailInfo = GVC_SPRINTF(@" (showing bytes %lu through %lu)", (long)adjustedStartOffset, (long)stopOffset);
	}
	
		// Start the hexdump out with an overview of the content
	NSMutableString *buf = [NSMutableString stringWithFormat:@"NSData %lu bytes %@:\n", (long)[self length], curtailInfo];
	
		// One row of 16-bytes at a time ...
    for ( NSUInteger i = adjustedStartOffset ; i < stopOffset ; i += 16 )
    {
			// Show the row in Hex first
        for ( NSUInteger j = 0 ; j < 16 ; j++ )
        {
            NSUInteger rowOffset = i+j;
            if (rowOffset < stopOffset)
            {
                [buf appendFormat:@"%02X ", bytes[rowOffset]];
            }
            else
            {
                [buf appendFormat:@"   "];
            }
        }
		
			// Now show in ASCII
        [buf appendString:@"| "];   
        for ( NSUInteger j = 0 ; j < 16 ; j++ )
        {
            NSUInteger rowOffset = i+j;
            if (rowOffset < stopOffset)
            {
                unsigned char theChar = bytes[rowOffset];
                if (theChar < 32 || theChar > 127)
                {
                    theChar ='.';
                }
                [buf appendFormat:@"%c", theChar];
            }
        }
		
			// If we're not on the last row, tack on a newline
		if (i+16 < stopOffset)
		{
			[buf appendString:@"\n"];
		}
	}
	
    return buf;	
}

- (NSData *)gvc_md5Digest
{
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5([self bytes], (unsigned int)[self length], result);	
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

- (NSData *)gvc_sha1Digest
{
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1([self bytes], (unsigned int)[self length], result);
    return [NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)gvc_hexString
{
	NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:([self length] * 2)];
	
    const unsigned char *dataBuffer = [self bytes];
    NSUInteger i;
    
    for (i = 0; i < [self length]; ++i)
	{
        [stringBuffer appendFormat:@"%02lx", (unsigned long)dataBuffer[i]];
	}
    
    return stringBuffer;
}

- (NSString *)gvc_base64Encoded
{
	const unsigned char	*bytes = [self bytes];
	NSMutableString *result = [NSMutableString stringWithCapacity:[self length]];
	unsigned long ixtext = 0;
	unsigned long lentext = [self length];
	long ctremaining = 0;
	unsigned char inbuf[3], outbuf[4];
	unsigned short i = 0;
	unsigned short charsonline = 0, ctcopy = 0;
	unsigned long ix = 0;
	
	while( YES )
	{
		ctremaining = (long)(lentext - ixtext);
		if( ctremaining <= 0 ) break;
		
		for( i = 0; i < 3; i++ ) {
			ix = ixtext + i;
			if( ix < lentext ) inbuf[i] = bytes[ix];
			else inbuf [i] = 0;
		}
		
		outbuf [0] = (inbuf [0] & 0xFC) >> 2;
		outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
		outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
		outbuf [3] = inbuf [2] & 0x3F;
		ctcopy = 4;
		
		switch( ctremaining )
		{
			case 1:
				ctcopy = 2;
				break;
			case 2:
				ctcopy = 3;
				break;
		}
		
		for( i = 0; i < ctcopy; i++ )
			[result appendFormat:@"%c", gvc_b64encodingTable[outbuf[i]]];
		
		for( i = ctcopy; i < 4; i++ )
			[result appendString:@"="];
		
		ixtext += 3;
		charsonline += 4;
	}
	
	return [NSString stringWithString:result];
}

+ (NSData *)gvc_Base64Decoded:(NSString *)encoded
{
	return [[encoded dataUsingEncoding:NSUTF8StringEncoding] gvc_base64Decoded];
}

- (NSData *)gvc_base64Decoded
{
	const unsigned char	*bytes = [self bytes];
	NSMutableData *result = [NSMutableData dataWithCapacity:((([self length] + 3) / 4) * 3)];

	gvc_initialize_b64decodingTable();
    
    unsigned char inbuf[4];
    unsigned char outbuf[3];
    unsigned char ch;
    int inindex;
    int len;
    
    while (*bytes)
    {
        inbuf[0] = 0;
        inbuf[1] = 0;
        inbuf[2] = 0;
        inbuf[3] = 0;
        outbuf[0] = 0;
        outbuf[1] = 0;
        outbuf[2] = 0;

        for (len = 0, inindex = 0; inindex < 4 && *bytes; inindex++)
        {
            ch = 0;
            while (*bytes && ch == 0)
            {
                ch = *bytes++;
                ch = (unsigned char)((ch < 43 || ch > 122) ? 0 : gvc_b64decodingTable[ch - 43]);
                if (ch)
                    ch = (unsigned char)((ch == '$') ? 0 : ch - 61);
            }
            if (ch)
            {
                len++;
                inbuf[inindex] = (unsigned char)(ch - 1);
            }
        }
        if (len > 0)
        {
            gvc_b64decodeBlock(inbuf, outbuf);
            for (int outindex = 0; outindex < len - 1; outindex++)
                [result appendBytes:&outbuf[outindex] length:1];
        }
    }

	return [NSData dataWithData:result];
}


- (NSRange) gvc_rangeOfData:(NSData *)pattern fromStart: (NSUInteger)start;
{
    return [self rangeOfData:pattern options:0 range:NSMakeRange(start, [self length] - start)];
}


@end


@implementation NSMutableData (GVCFoundation)

- (void)gvc_appendUTF8String: (NSString *) string;
{
	if ( gvc_IsEmpty(string) == NO )
		[self appendData:[string dataUsingEncoding: NSUTF8StringEncoding]];
}

- (void)gvc_appendUTF8Format:(NSString *) format, ...;
{
    va_list argList;
    va_start(argList, format);
    [self gvc_appendUTF8String:[[NSString alloc] initWithFormat:format arguments:argList]];
    va_end(argList);
}

- (void)gvc_removeDataRange:(NSRange)range;
{
    [self replaceBytesInRange:range withBytes: NULL length: 0];
}

@end
