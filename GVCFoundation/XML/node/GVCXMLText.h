//
//  DAXMLText.h
//
//  Created by David Aspinall on 03/02/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCXMLParsingModel.h"

/**
 * $Date: 2009-08-05 14:34:08 -0400 (Wed, 05 Aug 2009) $
 * $Rev: 31 $
 * $Author: david $
*/
@interface GVCXMLText : NSObject <GVCXMLTextContent, GVCXMLContent>

- (id)init;
- (id)initWithContent:(NSString *)string;

/** XMLTextContainer */
@property (strong, nonatomic) NSString *text;

- (void)appendText:(NSString *)value;
- (void)appendTextWithFormat:(NSString*)fmt, ...;

- (NSString *)normalizedText;
@end
