//
//  GVCXMLDigesterRule.h
//
//  Created by David Aspinall on 11-02-04.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GVCXMLDigester;
@class GVCXMLGenerator;

@interface GVCXMLDigesterRule : NSObject 

@property (weak, readwrite, nonatomic) GVCXMLDigester *digester;
@property (strong, nonatomic) NSString *namespaceURI;

- (void) didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict;
- (void) didFindCharacters:(NSString *)body;
- (void) didEndElement:(NSString *)elementName;

- (void) finishDigest;

- (void)writeConfiguration:(GVCXMLGenerator *)outputGenerator;

+ (GVCXMLDigesterRule *)ruleForCreateObject:(NSString *)clazz;
+ (GVCXMLDigesterRule *)ruleForCreateObjectFromAttribute:(NSString *)attributeName;
+ (GVCXMLDigesterRule *)ruleForParentChild:(NSString *)propertyName;
+ (GVCXMLDigesterRule *)ruleForParentChildFromAttribute:(NSString *)attributeName;
+ (GVCXMLDigesterRule *)ruleForSetPropertyText:(NSString *)propertyName;
+ (GVCXMLDigesterRule *)ruleForSetPropertyTextFromAttributeValue:(NSString *)attributeName;
+ (GVCXMLDigesterRule *)ruleForAttributeMapKeysAndValues:(NSString *)key, ...;

@end
