//
//  DAXMLDocType.h
//
//  Created by David Aspinall on 14/09/08.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCXMLParsingModel.h"

@interface GVCXMLDocType : NSObject <GVCXMLDocumentTypeDeclaration>
{
    NSString *elementName;
    NSString *publicID;
    NSString *systemID;
    NSString *internalSubset;
}

+ (id)docTypeWithName:(NSString *)name publicId:(NSString *)public systemId:(NSString *)system;

- (id)initWithName:(NSString *)name publicId:(NSString *)public systemId:(NSString *)system;

- (void)setElementName:(NSString *)name publicID:(NSString *)public systemID:(NSString *)system forInternalSubset:(NSString *)internal;

@property (retain, nonatomic) NSString *elementName;
@property (retain, nonatomic) NSString *publicID;
@property (retain, nonatomic) NSString *systemID;
@property (retain, nonatomic) NSString *internalSubset;

@end
