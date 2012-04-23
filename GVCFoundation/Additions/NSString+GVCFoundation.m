//
//  NSString+GVCFoundation.m
//  GVCFoundation
//
//  Created by David Aspinall on 11-09-28.
//  Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
//

#import "NSString+GVCFoundation.h"
#import "NSData+GVCFoundation.h"

#import "GVCMacros.h"
#import "GVCFunctions.h"

@implementation NSString (GVCFoundation)

#pragma mark - General Class Methods

+ (NSString *)gvc_EmptyString
{
	return @"";
}

+ (NSString *)gvc_StringWithUUID
{
	//create a new UUID
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString * string = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    CFRelease(uuid);
    return string;
}

#pragma mark - General Instance methods

- (NSString *)gvc_md5Hash
{
    NSString *hash = nil;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (data != nil)
    {	
        hash = [[data gvc_md5Digest] gvc_hexString];
    }
    return hash;
}

- (NSString *)gvc_StringWithCapitalizedFirstCharacter
{
    int len = [self length];
    if ( len == 1)
	{
		NSString *firstChar = [self substringToIndex:1];
		return GVC_SPRINTF( @"%@", [firstChar uppercaseString] );
	}
    else if ([self length] > 1)
    {
		NSString *firstChar = [self substringToIndex:1];
        return GVC_SPRINTF( @"%@%@", [firstChar uppercaseString], [self substringFromIndex:1] );
    }
	
	return self;
}

- (NSString *)gvc_TrimWhitespace 
{
	NSMutableString *sBuffer = [self mutableCopy];
	CFStringTrimWhitespace ((__bridge CFMutableStringRef) sBuffer);
	return sBuffer;
}

#pragma mark - file names

- (NSString *)gvc_stringByAppendingFilename:(NSString *)fname withExtension:(NSString *)ext
{
	NSString *result = self;
	if (gvc_IsEmpty(fname) == NO)
	{
		if (gvc_IsEmpty(ext) == NO)
			result = [self stringByAppendingPathComponent:GVC_SPRINTF(@"%@.%@", fname, ext )];
		else
			result = [self stringByAppendingPathComponent:fname];
	}
	return result;
}

#pragma mark - XML support

- (NSString *)gvc_XMLAttributeEscapedString
{
	NSMutableString *buffer = [NSMutableString stringWithCapacity:[self length]];
	
	NSCharacterSet *attributeCharToEscape = [NSCharacterSet gvc_XMLAttributeCharacterEscapeSet];
    // Look for characters to escape. If there are none can bail out quick without having had to allocate anything.
    NSRange searchRange = NSMakeRange(0, [self length]);
    NSRange range = [self rangeOfCharacterFromSet:attributeCharToEscape options:0 range:searchRange];
    if (range.location != NSNotFound)
	{
		while (searchRange.length)
		{
			// Write characters not needing to be escaped. Don't bother if there aren't any
			NSRange unescapedRange = searchRange;
			if (range.location != NSNotFound)
			{
				unescapedRange.length = range.location - searchRange.location;
			}
			
			if (unescapedRange.length > 0)
			{
				[buffer appendString:[self substringWithRange:unescapedRange]];
			}
			
			if (range.location != NSNotFound)
			{            
				GVC_ASSERT(range.length == 1, @"multi-character string cannot be XML entity");
				
				unichar ch = [self characterAtIndex:range.location];
				switch (ch)
				{
					case '&':
						[buffer appendString:@"&amp;"];
						break;
					case '<':
						[buffer appendString:@"&lt;"];
						break;
					case '>':
						[buffer appendString:@"&gt;"];
						break;
					case '\r':
						[buffer appendString:@"&#xD;"];
						break;
					case '\t':
						[buffer appendString:@"&#x9;"];
						break;
					case '\n':
						[buffer appendString:@"&#xA;"];
						break;
					case '"':
						[buffer appendString:@"&quot;"];
						break;
				}
			}
			else
			{
				break;  // no escapable characters were found so we must be done
			}
			
			
			// Continue the search
			searchRange.location = range.location + range.length;
			searchRange.length = [self length] - searchRange.location;
			range = [self rangeOfCharacterFromSet:attributeCharToEscape options:0 range:searchRange];
		}	
	}
	else
	{
		[buffer appendString:self];
	}
	
	return buffer;
}


- (NSString *)gvc_XMLEntityEscapedString:(BOOL)escapeQuotes
{
	NSMutableString *buffer = [NSMutableString stringWithCapacity:[self length]];
    NSCharacterSet *charactersToEntityEscape = [NSCharacterSet gvc_XMLEntityCharacterEscapeSet:escapeQuotes];
    
    // Look for characters to escape. If there are none can bail out quick without having had to allocate anything. #78710
    NSRange searchRange = NSMakeRange(0, [self length]);
    NSRange range = [self rangeOfCharacterFromSet:charactersToEntityEscape options:0 range:searchRange];
    if (range.location != NSNotFound)
	{
		while (searchRange.length)
		{
			// Write characters not needing to be escaped. Don't bother if there aren't any
			NSRange unescapedRange = searchRange;
			if (range.location != NSNotFound)
			{
				unescapedRange.length = range.location - searchRange.location;
			}
			
			if (unescapedRange.length)
			{
				[buffer appendString:[self substringWithRange:unescapedRange]];
			}
			
			if (range.location != NSNotFound)
			{            
				GVC_ASSERT(range.length == 1, @"multi-character string cannot be XML entity");
				
				unichar ch = [self characterAtIndex:range.location];
				switch (ch)
				{
					case '&':
						[buffer appendString:@"&amp;"];
						break;
					case '<':
						[buffer appendString:@"&lt;"];
						break;
					case '>':
						[buffer appendString:@"&gt;"];
						break;
					case '\'':
						[buffer appendString:@"&apos;"];
						break;
					case '"':
						[buffer appendString:@"&quot;"];
						break;
				}
			}
			else
			{
				break;  // no escapable characters were found so we must be done
			}
			
			
			// Continue the search
			searchRange.location = range.location + range.length;
			searchRange.length = [self length] - searchRange.location;
			range = [self rangeOfCharacterFromSet:charactersToEntityEscape options:0 range:searchRange];
		}	
	}
	else
	{
		[buffer appendString:self];
	}
	
	return buffer;
}

- (NSString *)gvc_XMLPrefixFromQualifiedName
{
    // minimum size for a fully qualified name is 'a:b'
	if ([self length] > 2)
	{
		NSArray *comps = [self componentsSeparatedByString:@":"];
		
		// if there is only one component, that means no prefix
		if ( [comps count] > 1 )
			return [comps objectAtIndex:0];
	}
    
	return nil;
}

- (NSString *)gvc_XMLLocalNameFromQualifiedName;
{
    // minimum size for a fully qualified name is 'a:b'
	if ([self length] > 2)
	{
		NSArray *comps = [self componentsSeparatedByString:@":"];
		// if there is only one component, that means no prefix so the qname and the local name are the same
		if ( [comps count] > 1 )
			return [comps objectAtIndex:1];
	}
	
	return self;
}

@end
