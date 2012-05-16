//
//  NSCharacterSet+GVCFoundation.h
//
//  Created by David Aspinall on 11-01-13.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSCharacterSet (GVCFoundation)


+ (NSCharacterSet *)gvc_ASCIICharacterSet;
+ (NSCharacterSet *)gvc_LinebreakCharacterSet;

+ (NSCharacterSet *)gvc_MIMETokenCharacterSet;
+ (NSCharacterSet *)gvc_MIMENonTokenCharacterSet;
+ (NSCharacterSet *)gvc_MIMETSpecialsCharacterSet;
+ (NSCharacterSet *)gvc_MIMEHeaderDefaultLiteralCharacterSet;

+ (NSCharacterSet *)gvc_XMLAttributeCharacterEscapeSet;

+ (NSCharacterSet *)gvc_XMLEntityCharacterEscapeSetWithoutQuote;
+ (NSCharacterSet *)gvc_XMLEntityCharacterEscapeSetWithQuote;
+ (NSCharacterSet *)gvc_XMLEntityCharacterEscapeSet:(BOOL)withQuote;

@end
