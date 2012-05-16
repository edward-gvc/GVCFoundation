/*
 * GVCMultipartResponseData.m
 * 
 * Created by David Aspinall on 12-05-13. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCMultipartResponseData.h"
#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "GVCNetworking.h"
#import "GVCHTTPHeader.h"
#import "GVCLogger.h"
#import "GVCDirectory.h"

#import "NSString+GVCFoundation.h"

typedef enum {
    GVCMultipartResponseData_STATE_initial,
    GVCMultipartResponseData_STATE_headers,
    GVCMultipartResponseData_STATE_end
} GVCMultipartResponseData_STATE;

@interface GVCMultipartResponseData ()
@property (assign, nonatomic) GVCMultipartResponseData_STATE multipart_state;
@property (strong, nonatomic) NSData *multipart_boundary;
@property (strong, nonatomic) NSData *multipart_boundary_end;

@property (strong, nonatomic) NSString *bufferFilename;
@property (strong, nonatomic) NSOutputStream *bufferOutputStream;

@property (strong, nonatomic) NSMutableArray *responseParts;
@property (strong, nonatomic) GVCNetResponseData *currentResponseData;
- (BOOL)createResponsePart:(NSError **)anError;
@end


@implementation GVCMultipartResponseData

@synthesize multipart_state;
@synthesize multipart_boundary;
@synthesize multipart_boundary_end;
@synthesize bufferFilename;
@synthesize bufferOutputStream;
@synthesize responseFilename;
@synthesize responseParts;
@synthesize currentResponseData;

- (id)init
{
    return [self initForFilename:nil];
}

- initForFilename:(NSString *)fName
{
    self = [super init];
	if ( self != nil )
	{
        [self setResponseFilename:fName];
        [self setResponseParts:[[NSMutableArray alloc] initWithCapacity:1]];
        [self setMultipart_state:GVCMultipartResponseData_STATE_initial];
	}
	
    return self;
}

- (BOOL)isMultipartResponse
{
    GVC_ASSERT_NOT_NIL([self httpHeaders]);

    BOOL isMultipart = NO;
    GVCHTTPHeader *contentType = [[self httpHeaders] headerForKey:GVC_HTTP_HEADER_KEY_content_type];
    if ((contentType != nil) && ([[contentType headerValue] gvc_beginsWith:@"multipart"] == YES))
    {
        isMultipart = YES;
    }
    return isMultipart;
}

- (BOOL)createResponsePart:(NSError **)err
{
    BOOL success = ([self currentResponseData] == nil) || ([[self currentResponseData] closeData:err] == YES);
    if (success == YES)
    {
        [self setCurrentResponseData:nil];
        if ( gvc_IsEmpty([self responseFilename]) == NO)
        {
            NSUInteger indx = [[self responseParts] count] + 1;
            NSString *partFilename = GVC_SPRINTF(@"%@.%d", [self responseFilename], indx);
            [self setCurrentResponseData:[[GVCStreamResponseData alloc] initForFilename:partFilename]];
        }
        else
        {
            [self setCurrentResponseData:[[GVCMemoryResponseData alloc] init]];
        }
        success = [[self currentResponseData] openData:NSURLResponseUnknownLength error:err];
        [[self responseParts] addObject:[self currentResponseData]];
    }

    return success;
}

- (BOOL)openData:(long long)expectedLength error:(NSError **)err
{
    BOOL success = [super openData:expectedLength error:err];
    GVC_ASSERT_NOT_NIL([self httpHeaders]);
    
    if ([self isMultipartResponse])
    {
        GVCHTTPHeader *contentType = [[self httpHeaders] headerForKey:GVC_HTTP_HEADER_KEY_content_type];
        NSString *boundary = [contentType parameterForKey:@"boundary"];
        GVC_ASSERT_NOT_NIL(boundary);
        
        NSString *boundaryStart = GVC_SPRINTF(@"--%@", boundary);
        NSString *boundaryEnd = GVC_SPRINTF(@"--%@--", boundary);
        [self setMultipart_boundary:[boundaryStart dataUsingEncoding:[self responseEncoding]]];
        [self setMultipart_boundary_end:[boundaryEnd dataUsingEncoding:[self responseEncoding]]];
    }
    
//    [self setBufferFilename:[[GVCDirectory TempDirectory] fullpathForFile:[NSString gvc_StringWithUUID]]];
    GVCDirectory *dir = [[[GVCDirectory alloc] initWithRootPath:@"/tmp/"] createSubdirectory:@"mime-test"];
    [self setBufferFilename:[dir fullpathForFile:@"Message"]];
    [self setBufferOutputStream:[NSOutputStream outputStreamToFileAtPath:[self bufferFilename] append:NO]];
    [[self bufferOutputStream] open];

	return success;
}

- (BOOL)closeData:(NSError **)err
{
    BOOL success = [super closeData:err];
    
    [[self bufferOutputStream] close];

//    NSInputStream *input = [NSInputStream inputStreamWithFileAtPath:[self bufferFilename]];
    
    
	return success;
}

- (BOOL)appendData:(NSData *)data error:(NSError **)err
{
	BOOL success = [super appendData:data error:err];
    
    if (success == YES)
	{
		GVC_ASSERT([self bufferOutputStream] != nil, @"No response output stream");
        
		const uint8_t * dataPtr = [data bytes];
		NSUInteger dataLength = [data length];
		NSUInteger dataOffset = 0;
		NSInteger bytesWritten = 0;
		
		do 
		{
			if (dataOffset == dataLength) 
			{
				break;
			}
			
			bytesWritten = [[self bufferOutputStream] write:&dataPtr[dataOffset] maxLength:dataLength - dataOffset];
			if (bytesWritten <= 0) 
			{
				*err = [[self bufferOutputStream] streamError];
				if (*err == nil) 
				{
					*err = [NSError errorWithDomain:GVCNetOperationErrorDomain code:GVC_NetOperation_ErrorType_OUTPUT_STREAM userInfo:nil];
				}
				success = NO;
				break;
			}
			else
			{
				dataOffset += bytesWritten;
			}
		} while (YES);
	}
    
	if ( success == YES )
	{
		[self setTotalBytesRead:[self totalBytesRead] + [data length]];
	}
	
	return success;
}

//- (BOOL)appendData:(NSData *)data error:(NSError **)err
//{
//    BOOL success = [super appendData:data error:err];
//    if ( success == YES )
//    {
//        if ( [self isMultipartResponse] == NO )
//        {
//            // not a multipart response, just append the whole response to one responseData
//            if ( [self currentResponseData] == nil )
//            {
//                success = [self createResponsePart:err];
//            }
//            
//            if ( success == YES )
//            {
//                success = [[self currentResponseData] appendData:data error:err];
//            }
//        }
//        else
//        {
//            if ( [self buffer] == nil )
//            {
//                [self setBuffer:[[NSMutableData alloc] initWithLength:[data length]]];
//            }
//            [buffer appendData:data];
//            
//            switch ([self multipart_state]) 
//            {
//                case GVCMultipartResponseData_STATE_initial:
//                {
//                    NSRange start = [buffer rangeOfData:[self multipart_boundary] options:0 range:NSMakeRange(0, [buffer length])];
//                    if ( start.location != NSNotFound )
//                    {
//                        if ( start.location > 0 )
//                        {
//                            // append everything up to the start location to the previous response part
//                            NSData *endOfPreviousPart = [buffer subdataWithRange:NSMakeRange(0, start.location)];
//                            success = [[self currentResponseData] appendData:endOfPreviousPart error:err];
//
//                        }
//
//                        NSData *startOfNewPart = [buffer subdataWithRange:NSMakeRange(NSMaxRange(start), [buffer length])];
//                        
//                    }
//                }
//                    break;
//                    
//                case GVCMultipartResponseData_STATE_headers:
//                    break;
//
//                case GVCMultipartResponseData_STATE_end:
//                    break;
//
//                default:
//                    break;
//            }
//        }
//    }
//	return success;
//}


@end
