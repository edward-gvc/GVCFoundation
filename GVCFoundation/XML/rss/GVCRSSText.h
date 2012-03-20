/*
 * GVCRSSText.h
 * 
 * Created by David Aspinall on 12-03-15. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCRSSNode.h"

@interface GVCRSSText : GVCRSSNode

@property (strong, nonatomic) NSString *textType;

@property (strong, nonatomic) NSString *textContent;
@property (strong, nonatomic) NSData *textCDATA;

- (BOOL)hasContent;

@end
