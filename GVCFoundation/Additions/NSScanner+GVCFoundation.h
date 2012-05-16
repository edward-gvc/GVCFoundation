/*
 * NSScanner+GVCFoundation.h
 * 
 * Created by David Aspinall on 12-05-13. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@interface NSScanner (GVCFoundation)

/** modified from OmniGroup's OmniFoundation/OpenStepExtensions.subproj/NSScanner-OFExtensions.hm 
 */
- (BOOL)gvc_scanStringOfLength:(NSUInteger)length intoString:(NSString **)result;
- (BOOL)gvc_scanStringWithEscape:(NSString *)escape terminator:(NSString *)quoteMark intoString:(NSString **)output;

@end
