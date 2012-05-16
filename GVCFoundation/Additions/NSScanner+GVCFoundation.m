/*
 * NSScanner+GVCFoundation.m
 * 
 * Created by David Aspinall on 12-05-13. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "NSScanner+GVCFoundation.h"
#import "GVCFunctions.h"
#import "GVCMacros.h"

#import "NSString+GVCFoundation.h"

@implementation NSScanner (GVCFoundation)

- (BOOL)gvc_scanStringOfLength:(NSUInteger)length intoString:(NSString **)result
{
    BOOL success = NO;
    NSString *string = [self string];
    NSUInteger scanLocation = [self scanLocation];
    if (scanLocation + length <= [string length])
    {
        if (result)
            *result = [string substringWithRange: NSMakeRange(scanLocation, length)];
        [self setScanLocation:scanLocation + length];
        success = YES;
    }
    return success;
}

- (BOOL)gvc_scanStringWithEscape:(NSString *)escape terminator:(NSString *)quoteMark intoString:(NSString **)output
{
    GVC_ASSERT_NOT_NIL(escape);
    GVC_ASSERT_NOT_NIL(quoteMark);
    
    BOOL success = NO;
    if ([self isAtEnd] == NO)
    {
        NSString *value = nil;
        NSMutableString *buffer = nil;
        
        NSCharacterSet *oldCharactersToBeSkipped = [self charactersToBeSkipped];
        [self setCharactersToBeSkipped:nil];

        NSMutableString *prefixes = [[NSMutableString alloc] initWithCapacity:2];
        [prefixes appendUniCharacter:[escape characterAtIndex:0]];
        [prefixes appendUniCharacter:[quoteMark characterAtIndex:0]];
        NSCharacterSet *stopSet = [NSCharacterSet characterSetWithCharactersInString:prefixes];
        
        do 
        {
            NSString *fragment;
            
            if ([self scanUpToCharactersFromSet:stopSet intoString:&fragment]) 
            {
                if ((value != nil) && (buffer == nil)) 
                {
                    buffer = [value mutableCopy];
                    value = nil;
                }
                
                if (buffer != nil)
                {
                    [buffer appendString:fragment];
                }
                else
                {
                    value = fragment;
                }
            }
            
            if ([self scanString:quoteMark intoString:NULL])
            {
                break;
            }
            
            /* Two cases: either we scan the escape sequence successfully, and then we pull one (uninterpreted) character out of the string into the buffer; or we don't scan the escape sequence successfully (i.e. false alarm from the stopSet), in which we pull one uninterpreted character out of the string into the buffer. */
            
            if (buffer == nil)
            {
                if (value != nil)
                {
                    buffer = [value mutableCopy];
                    value = nil;
                }
                else
                {
                    buffer = [[NSMutableString alloc] init];
                }
            }
            
            [self scanString:escape intoString:NULL];
            if ([self gvc_scanStringOfLength:1 intoString:&fragment])
            {
                [buffer appendString:fragment];
            }
        } while ([self isAtEnd] == NO);
        
        [self setCharactersToBeSkipped:oldCharactersToBeSkipped];
        
        if (buffer != nil) 
        {
            if (output)
                *output = [buffer copy];
            success = YES;
        }
        else if (value != nil)
        {
            if (output)
                *output = value;
            success = YES;
        }
        else if ([self isAtEnd] == YES)
        {
            // Edge case --- we scanned an escape sequence and then hit EOF immediately afterwards. Still, we *did* advance our scan location, so we should return YES.
            if (output)
                *output = @"";
            success = YES;
        }
    }
    
    return success;
}

@end
