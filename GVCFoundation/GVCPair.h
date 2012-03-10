//
//  DAPair.h
//
//  Created by David Aspinall on 05/08/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * $Date: 2009-01-21 16:53:51 -0500 (Wed, 21 Jan 2009) $
 * $Rev: 125 $
 * $Author: david $
*/
@interface GVCPair : NSObject 

@property (readonly, nonatomic, strong) id left;
@property (readonly, nonatomic, strong) id right;

- (id)initWith:(id)obj and:(id)obj2;

- (BOOL)isEqualToPair:(GVCPair *)object;

@end
