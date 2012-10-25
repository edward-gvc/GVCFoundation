//
//  GVCParser.m
//
//  Created by David Aspinall on 10-12-06.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCParser.h"
#import "GVCMacros.h"
#import "GVCLogger.h"
#import "GVCFunctions.h"

#import "NSArray+GVCFoundation.h"
#import "NSString+GVCFoundation.h"

@interface GVCParser ()
@property (strong, nonatomic) NSScanner *scanner;

@end

@implementation GVCParser

- (id)initWithDelegate:(id <GVCParserDelegate>)del separator:(NSString *)aSep fieldNames:(NSArray *)names;
{
	self = [super init];
	if (self != nil) 
	{
		[self setDelegate:del];
		[self setFieldNames:[names mutableCopy]];
		[self setFieldSeparator:aSep];
		[self setCancelled:NO];
		if ([[self fieldSeparator] length] == 1)
		{
			[self setSeparatorIsSingleChar:YES];
		}
		
		NSMutableCharacterSet *endTextMutableCharacterSet = [[NSCharacterSet newlineCharacterSet] mutableCopy];
		[endTextMutableCharacterSet addCharactersInString:@"\""];
		[endTextMutableCharacterSet addCharactersInString:[[self fieldSeparator] substringToIndex:1]];
		[self setEndTextCharacterSet:endTextMutableCharacterSet];
	}
	
	return self;
}

- (NSString *)fieldNameAtIndex:(NSUInteger)idx
{
	if ( [self fieldNames] == nil )
	{
		[self setFieldNames:[[NSMutableArray alloc] initWithCapacity:10]];
	}
	
	if ( [[self fieldNames] count] < idx + 1 )
	{
		// assign default field names
		NSUInteger cnt = [[self fieldNames] count];
		for ( ; [[self fieldNames] count] < idx + 1 ; cnt ++ )
		{
			NSString *fName = GVC_SPRINTF( @"FIELD_%ld", (long)(cnt +1) );
			if ( [[self fieldNames] containsObject:fName] == NO )
			{
				[[self fieldNames] addObject:fName];
			}
		}
	}
	
	return [[self fieldNames] objectAtIndex:idx];
}

- (BOOL)parseFilename:(NSString *)afile error:(NSError **)err
{
	return [self parseFilename:afile withEncoding:NSUTF8StringEncoding error:err];
}

- (BOOL)parseFilename:(NSString *)afile withEncoding:(NSStringEncoding)encode error:(NSError **)err
{
	GVC_ASSERT( gvc_IsEmpty(afile) == NO, @"Cannot parse nil file" );
	BOOL success = NO;

	id <GVCParserDelegate>strongDelegate = [self delegate];
	if ( strongDelegate != nil )
		[strongDelegate parser:self didStartFile:afile];
	
	NSString *contentString = [NSString stringWithContentsOfFile:afile encoding:encode error:err];
	if ( gvc_IsEmpty(contentString) == NO )
	{
		success = [self parseString:contentString error:err];
	}
	else 
	{
        // TODO:
		// GVCLogNSError(GVCErrorLogLevel_ERROR, *err);
	}

	if ( strongDelegate != nil )
		[strongDelegate parser:self didEndFile:afile];
	
	return success;
}

- (BOOL)parseString:(NSString *)content error:(NSError **)err
{
	BOOL success = NO;

	[self setScanner:[[NSScanner alloc] initWithString:content]];
	[[self scanner] setCharactersToBeSkipped:[[NSCharacterSet alloc] init]];
	
	success = [self performParse:err];
	
	return success;
}

- (BOOL)performParse:(NSError **)err
{
	GVC_SUBCLASS_RESPONSIBLE
    return NO;
}


@end
