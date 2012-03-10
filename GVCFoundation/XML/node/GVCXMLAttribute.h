//
//  DAXMLAttribute.h
//
//  Created by David Aspinall on 14/09/08.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCXMLParsingModel.h"


@interface GVCXMLAttribute : NSObject <GVCXMLAttributeContent>
{
    NSString *localname;
    NSString *attributeValue;
	
    id <GVCXMLNamespaceDeclaration>defaultNamespace;
	
    GVC_XML_AttributeType type;
}

@property (readwrite, strong, nonatomic) NSString *localname;
@property (readwrite, strong, nonatomic) id <GVCXMLNamespaceDeclaration> defaultNamespace;
@property (readwrite, strong, nonatomic) NSString *attributeValue;
@property (assign, nonatomic) GVC_XML_AttributeType type;

- (NSString *)qualifiedName;

- initWithName:(NSString *)n value:(NSString *)v;
- initWithName:(NSString *)n value:(NSString *)v forType:(GVC_XML_AttributeType)t;
- initWithName:(NSString *)n value:(NSString *)v inNamespace:(id <GVCXMLNamespaceDeclaration>)nspace forType:(GVC_XML_AttributeType)t;

- (void)setName:(NSString *)n value:(NSString *)v inNamespace:(id <GVCXMLNamespaceDeclaration>)nspace forType:(GVC_XML_AttributeType)t;

@end
