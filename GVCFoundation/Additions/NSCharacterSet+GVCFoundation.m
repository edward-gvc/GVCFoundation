//
//  NSCharacterSet+GVCFoundation.m
//
//  Created by David Aspinall on 11-01-13.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "NSCharacterSet+GVCFoundation.h"


@implementation NSCharacterSet (GVCFoundation)

static NSCharacterSet *ASCIICharacterSet;
static NSCharacterSet *LinebreakCharacterSet;

static NSCharacterSet *MIMETokenCharacterSet;
static NSCharacterSet *MIMENonTokenCharacterSet;
static NSCharacterSet *MIMETSpecialsCharacterSet;
static NSCharacterSet *MIMEHeaderDefaultLiteralCharacterSet;

static NSCharacterSet *XMLAttributeEscape;
static NSCharacterSet *XMLEntityEscapeWithQuot;
static NSCharacterSet *XMLEntityEscapeWithoutQuot;

+ (NSCharacterSet *)gvc_ASCIICharacterSet
{
    static dispatch_once_t gvc_ASCIICharacterSetDispatch;
	dispatch_once(&gvc_ASCIICharacterSetDispatch, ^{
        ASCIICharacterSet = [NSCharacterSet characterSetWithRange:NSMakeRange(0, 127)];
    });
    return ASCIICharacterSet;
}

+ (NSCharacterSet *)gvc_LinebreakCharacterSet
{
    static dispatch_once_t gvc_LinebreakCharacterSetDispatch;
	dispatch_once(&gvc_LinebreakCharacterSetDispatch, ^{
        LinebreakCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"\r\n"];
    });
    return LinebreakCharacterSet;
}

+ (NSCharacterSet *)gvc_MIMETokenCharacterSet
{
    static dispatch_once_t gvc_MIMETokenCharacterSetDispatch;
	dispatch_once(&gvc_MIMETokenCharacterSetDispatch, ^{
        NSMutableCharacterSet *workingSet = [[self gvc_MIMETSpecialsCharacterSet] mutableCopy];
        [workingSet invert];
        [workingSet formIntersectionWithCharacterSet:[NSCharacterSet characterSetWithRange:NSMakeRange(32, 95)]];
        MIMETokenCharacterSet = [workingSet copy];
    });
    return MIMETokenCharacterSet;
}

+ (NSCharacterSet *)gvc_MIMENonTokenCharacterSet
{
    static dispatch_once_t gvc_MIMENonTokenCharacterSetDispatch;
	dispatch_once(&gvc_MIMENonTokenCharacterSetDispatch, ^{
        MIMENonTokenCharacterSet = [[self gvc_MIMETokenCharacterSet] invertedSet];
    });
    return MIMENonTokenCharacterSet;
}
+ (NSCharacterSet *)gvc_MIMETSpecialsCharacterSet
{
    static dispatch_once_t gvc_MIMETSpecialsCharacterSetDispatch;
	dispatch_once(&gvc_MIMETSpecialsCharacterSetDispatch, ^{
        MIMETSpecialsCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"()<>@,;:\\\"/[]?="];
    });
    return MIMETSpecialsCharacterSet;
}
+ (NSCharacterSet *)gvc_MIMEHeaderDefaultLiteralCharacterSet
{
    static dispatch_once_t gvc_MIMEHeaderDefaultLiteralCharacterSetDispatch;
	dispatch_once(&gvc_MIMEHeaderDefaultLiteralCharacterSetDispatch, ^{
        NSMutableCharacterSet *workingSet = [[NSCharacterSet characterSetWithRange:NSMakeRange(32, 95)] mutableCopy];
        [workingSet removeCharactersInString:@"=?_ "];
        MIMEHeaderDefaultLiteralCharacterSet = [workingSet copy];
    });
    return MIMEHeaderDefaultLiteralCharacterSet;
}


+ (NSCharacterSet *)gvc_XMLAttributeCharacterEscapeSet
{
	// check the static variable to avoid MUTEX block if possible
	if ( XMLAttributeEscape == nil )
	{
		@synchronized (self)
		{
			// check again to avoid race conditions
			if ( XMLAttributeEscape == nil )
			{
				XMLAttributeEscape = [NSCharacterSet characterSetWithCharactersInString:@"<>\"&\r\n\t"];
			}
		}
	}
	return XMLAttributeEscape;
}

+ (NSCharacterSet *)gvc_XMLEntityCharacterEscapeSetWithoutQuote
{
	// check the static variable to avoid MUTEX block if possible
	if ( XMLEntityEscapeWithoutQuot == nil )
	{
		@synchronized (self)
		{
			// check again to avoid race conditions
			if (XMLEntityEscapeWithoutQuot == nil)
			{
				XMLEntityEscapeWithoutQuot = [NSCharacterSet characterSetWithCharactersInString:@"&<>"];
			}
		}
	}
	return XMLEntityEscapeWithoutQuot;
}

+ (NSCharacterSet *)gvc_XMLEntityCharacterEscapeSetWithQuote
{
	// check the static variable to avoid MUTEX block if possible
	if ( XMLEntityEscapeWithQuot == nil )
	{
		@synchronized (self)
		{
			// check again to avoid race conditions
			if (XMLEntityEscapeWithQuot == nil)
			{
				XMLEntityEscapeWithQuot = [NSCharacterSet characterSetWithCharactersInString:@"&<>\"'"];
			}
		}
	}
	return XMLEntityEscapeWithQuot;
}

+ (NSCharacterSet *)gvc_XMLEntityCharacterEscapeSet:(BOOL)withQuote
{
	if ( withQuote == YES )
		return [self gvc_XMLEntityCharacterEscapeSetWithQuote];
	
	return [self gvc_XMLEntityCharacterEscapeSetWithoutQuote];
}



@end
