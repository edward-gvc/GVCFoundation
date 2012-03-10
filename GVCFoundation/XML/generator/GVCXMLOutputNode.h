//
//  GVCXMLOutputNode.h
//  HL7ParseTest
//
//  Created by David Aspinall on 11-01-14.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCXMLParsingModel.h"

@interface GVCXMLOutputNode : NSObject 

- (id)initWithName:(NSString *)n andAttributes:(NSArray *)a forNamespaces:(NSArray *)sp;

@property (strong,nonatomic) NSString *nodeName;
@property (strong,nonatomic) NSMutableArray *namespaces;
@property (strong,nonatomic) NSMutableArray *attributes;

- (void)addAttribute:(NSString *)attribute value:(id)value;
- (void)addNamespace:(NSString *)prefix uri:(id)value;
- (void)addNamespace:(id <GVCXMLNamespaceDeclaration>)nmspValue;

@end
