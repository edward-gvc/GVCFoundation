//
//  GVCXMLDigesterRule.h
//
//  Created by David Aspinall on 11-02-04.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GVCXMLDigester;
@class GVCXMLGenerator;

typedef enum _GVC_XML_DigesterRule_Order
{
	GVC_XML_DigesterRule_Order_HIGH,
	GVC_XML_DigesterRule_Order_MED,
	GVC_XML_DigesterRule_Order_LOW
} GVC_XML_DigesterRule_Order;

@interface GVCXMLDigesterRule : NSObject 

- (GVC_XML_DigesterRule_Order)rulePriority;

@property (weak, readwrite, nonatomic) GVCXMLDigester *digester;
@property (strong, nonatomic) NSString *namespaceURI;

- (void) didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict;
- (void) didFindCharacters:(NSString *)body;
- (void) didFindCDATA:(NSData *)body;
- (void) didEndElement:(NSString *)elementName;

- (void) finishDigest;

- (void)writeConfiguration:(GVCXMLGenerator *)outputGenerator;

+ (GVCXMLDigesterRule *)ruleForCreateObject:(NSString *)clazz;
+ (GVCXMLDigesterRule *)ruleForCreateObjectFromAttribute:(NSString *)attributeName;
+ (GVCXMLDigesterRule *)ruleForParentChild:(NSString *)propertyName;
+ (GVCXMLDigesterRule *)ruleForParentChildFromAttribute:(NSString *)attributeName;
+ (GVCXMLDigesterRule *)ruleForSetPropertyText:(NSString *)propertyName;
+ (GVCXMLDigesterRule *)ruleForSetPropertyCDATA:(NSString *)propertyName;
+ (GVCXMLDigesterRule *)ruleForSetPropertyTextFromAttributeValue:(NSString *)attributeName;
+ (GVCXMLDigesterRule *)ruleForAttributeMapKeysAndValues:(NSString *)key, ...;

@end
