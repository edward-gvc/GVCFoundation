//
//  DAXMLComment.h
//
//  Created by David Aspinall on 04/02/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCXMLParsingModel.h"
#import "GVCXMLText.h"

@class GVCXMLGenerator;

/**
 * $Date: 2009-08-05 14:34:08 -0400 (Wed, 05 Aug 2009) $
 * $Rev: 31 $
 * $Author: david $
*/
@interface GVCXMLComment : GVCXMLText <GVCXMLCommentNode>
{

}

- (id)initWithComment:(NSString *)cmt;

- (void)generateOutput:(GVCXMLGenerator *)generator;

@end
