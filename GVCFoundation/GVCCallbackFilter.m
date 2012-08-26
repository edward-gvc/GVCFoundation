//
//  GVCCallbackParser.m
//  HL7ParseTest
//
//  Created by David Aspinall on 11-03-29.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCCallbackFilter.h"

#import "GVCStack.h"
#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "GVCLogger.h"
#import "NSString+GVCFoundation.h"

typedef enum {
	GVCCallbackNodeType_ROOT,
	GVCCallbackNodeType_STR,
	GVCCallbackNodeType_MTH
} GVCCallbackNodeType;


@interface  GVCCallbackNode  : NSObject 

+ (GVCCallbackNode *)node:(GVCCallbackNodeType)t;

- (id)initForType:(GVCCallbackNodeType)t;

@property (assign) GVCCallbackNodeType type;
@property (strong, nonatomic) NSMutableString *buffer;
@property (strong, nonatomic) NSMutableArray *children;

- (void)addChild:(GVCCallbackNode *)m;
- (void)append:(UniChar)c;

- (NSString *)string;

@end

@implementation GVCCallbackNode

@synthesize type;
@synthesize buffer;
@synthesize children;

+ (GVCCallbackNode *)node:(GVCCallbackNodeType)t
{
	return [[GVCCallbackNode alloc] initForType:t];
}

- (id)init
{
	return [self initForType:GVCCallbackNodeType_STR];
}

- (id)initForType:(GVCCallbackNodeType)t;
{
    self = [super init];
    if (self != nil)
	{
		type = t;
		[self setBuffer:[NSMutableString stringWithCapacity:10]];
		[self setChildren:[NSMutableArray arrayWithCapacity:10]];
    }
    return self;
}

- (void)addChild:(GVCCallbackNode *)m
{
	[children addObject:m];
}
- (void)append:(UniChar)c
{
	[buffer appendString:[NSString stringWithFormat: @"%C", c]];
}

- (NSString *)string
{
	return buffer;
}

@end


@interface GVCCallbackFilter ()
- (void)writeOutput:(GVCCallbackNode *)node callback:(NSObject *)obj;
- (void)writeOutputArray:(NSArray *)children callback:(NSObject *)obj;
@end

@implementation GVCCallbackFilter

@synthesize startMarker;
@synthesize endMarker;
@synthesize source;
@synthesize output;
@synthesize callback;

- (id)init 
{
    self = [super init];
    if (self != nil)
	{
		[self setStartMarker:'['];
		[self setEndMarker:']'];
    }
    return self;
}

- (GVCCallbackNode *)parseInput
{
	GVCCallbackNode * root = [GVCCallbackNode node:GVCCallbackNodeType_ROOT];

	GVCCallbackNode * current = root;
	GVCStack *stack = [[GVCStack alloc] init];
	NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
		//NSCharacterSet *alpha = [NSCharacterSet alphanumericCharacterSet];

	NSString *stringSource = [[NSString alloc] initWithData:source encoding:[output stringEncoding]];

	[stack pushObject:root];

	NSUInteger position = 0;
	NSUInteger length = [stringSource length];
	
	while ( position < length )
	{
		UniChar data = [stringSource characterAtIndex:position];
		if ( data == [self startMarker] )
		{
			current = [GVCCallbackNode node:GVCCallbackNodeType_MTH];
			[(GVCCallbackNode *)[stack peekObject] addChild:current];
			[stack pushObject:current];
		}
		else if ( data == [self endMarker] )
		{
			[stack popObject];
			current = (GVCCallbackNode *)[stack peekObject];
		}
		else if ([whitespace characterIsMember:data] == YES) // || ((data != '.') && ([alpha characterIsMember:data] == NO)))
		{
			if ( [current type] != GVCCallbackNodeType_STR )
			{
				current = [GVCCallbackNode node:GVCCallbackNodeType_STR];
				[(GVCCallbackNode *)[stack peekObject] addChild:current];
			}
			[current append:data];
		}
		else
		{
			if (([current type] == GVCCallbackNodeType_ROOT) || ([[current children] count] > 0))
			{
				current = [GVCCallbackNode node:GVCCallbackNodeType_STR];
				[(GVCCallbackNode *)[stack peekObject] addChild:current];
			}
			[current append:data];
		}
		
		position ++;
	}
	
	return root;
}

- (void)writeOutput:(GVCCallbackNode *)node callback:(NSObject *)obj
{
	if ( [node type] == GVCCallbackNodeType_STR )
	{
		[[self output] writeString:[node string]];
	}
	else
	{
		NSString *keyPrefix = [node string];
		NSString *format = nil;
		NSObject *value = nil;
		NSRange range = [keyPrefix rangeOfString:@"@format"];
		if ( range.length == 7 )
		{
			format = [keyPrefix substringFromIndex:range.location + range.length + 1];
			keyPrefix = [keyPrefix substringToIndex:range.location - 1];
		}
		
		@try {
			value = [obj valueForKeyPath:keyPrefix];
		}
		@catch (NSException *objExc) 
		{
			GVCLogError(@"invalid key '%@' on obj %@", [node string], obj );
			if (([@"NSUnknownKeyException" isEqualToString:[objExc name]] == YES) && ([self callback] != obj))
			{
				@try {
					value = [[self callback] valueForKeyPath:[node string]];
				}
				@catch (NSException *callExc) 
				{
					GVCLogError(@"  also invalid key '%@' on obj %@", [node string], callback );
				}
			}
		}
		
		if ((value != nil) && (gvc_IsEmpty(format) == NO))
		{
			if ( [value isKindOfClass:[NSDate class]] == YES )
			{
				NSDateFormatter *standardFormat = [[NSDateFormatter alloc] init];
				[standardFormat setDateFormat:format];
				value = [standardFormat stringFromDate:(NSDate *)value];
			}
			else if ( [value isKindOfClass:[NSNumber class]] == YES )
			{
				NSNumberFormatter *standardFormat = [[NSNumberFormatter alloc] init];
				
				[standardFormat setNumberStyle:NSNumberFormatterDecimalStyle];
				value = [standardFormat stringFromNumber:(NSNumber *)value];
			}
		}
		
		if ([[node children] count] == 0)
		{
			if ((value == nil) || (value == [NSNull null]))
			{
					// FIXME
				[[self output] writeString:@"-null-"];
			}
			else
			{
				[[self output] writeString:[value description]];
			}
		}
		else
		{
			if ( [value isKindOfClass:[NSArray class]] == YES )
			{
				NSArray *arrayValue = (NSArray *)value;
				for (NSObject *item in arrayValue)
				{
					[self writeOutputArray:[node children] callback:item];
				}
			}
			else if (([value isKindOfClass:[NSNumber class]] == YES) && ([(NSNumber *)value intValue] > 0))
			{
				[self writeOutputArray:[node children] callback:obj];
			}
			else if ( value != nil )
			{
				[self writeOutputArray:[node children] callback:obj];
			}
		}
	}
}

- (void)writeOutputArray:(NSArray *)children callback:(NSObject *)obj
{
	for (GVCCallbackNode *item in children)
	{
		[self writeOutput:item callback:obj];
	}
}

- (void)process
{
	GVCCallbackNode *root = [self parseInput];

	[[self output] openWriter];
	[self writeOutputArray:[root children] callback:[self callback]];
	[[self output] closeWriter];
}

@end
