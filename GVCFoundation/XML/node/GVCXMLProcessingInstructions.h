//
//  DAXMLProcessingInstructions.h
//
//  Created by David Aspinall on 04/02/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCXMLParsingModel.h"

/**
 * $Date: 2009-08-05 14:34:08 -0400 (Wed, 05 Aug 2009) $
 * $Rev: 31 $
 * $Author: david $
*/
@interface GVCXMLProcessingInstructions : NSObject <GVCXMLContent, GVCXMLProcessingInstructionsNode>

- (id)initTarget:(NSString *)targt forData:(NSString *)dta;

// XMLProcessingInstructions
@property (strong, nonatomic) NSString *target;
@property (strong, nonatomic) NSString *data;

@end
