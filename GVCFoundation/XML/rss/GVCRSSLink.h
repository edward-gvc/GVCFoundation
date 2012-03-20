/*
 * GVCRSSLink.h
 * 
 * Created by David Aspinall on 12-03-13. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCRSSText.h"

@interface GVCRSSLink : GVCRSSText

@property (strong, nonatomic) NSString *linkHref;
@property (strong, nonatomic) NSString *linkRel;
@property (strong, nonatomic) NSString *linkType;
@property (strong, nonatomic) NSString *linkHreflang;
@property (strong, nonatomic) NSString *linkTitle;
@property (strong, nonatomic) NSString *linkLength;

@property (strong, nonatomic) NSString *linkIsPermaLink;
@end
