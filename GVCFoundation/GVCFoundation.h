/**
 * Header for GVCFoundation
 * Author: daspinall
 */

#ifndef GVCFoundation_h
#define GVCFoundation_h


/* 
 * Additions 
 */
#import "NSArray+GVCFoundation.h"
#import "NSBundle+GVCFoundation.h"
#import "NSCharacterSet+GVCFoundation.h"
#import "NSData+GVCFoundation.h"
#import "NSDictionary+GVCFoundation.h"
#import "NSError+GVCFoundation.h"
#import "NSFileManager+GVCFoundation.h"
#import "NSString+GVCFoundation.h"

/* 
 * Cache 
 */
#import "GVCCache.h"
#import "GVCCacheNode.h"

/* 
 * 
 */
#import "GVCDirectory.h"
#import "GVCFileHandleWriter.h"
#import "GVCFileWriter.h"
#import "GVCFunctions.h"
#import "GVCLogger.h"
#import "GVCMacros.h"
#import "GVCPair.h"
#import "GVCReaderWriter.h"
#import "GVCStack.h"
#import "GVCStopwatch.h"
#import "GVCStringWriter.h"
#import "GVCTextGenerator.h"

/* 
 * Networking 
 */
#import "GVCHTTPOperation.h"
#import "GVCNetOperation.h"
#import "GVCNetResponseData.h"

/* 
 * Operations 
 */
#import "GVCFileOperation.h"
#import "GVCOperation.h"
#import "GVCRunLoopOperation.h"
#import "GVCXMLParserOperation.h"

/* 
 * Parsing 
 */
#import "GVCCSVParser.h"
#import "GVCParser.h"

/* 
 * XML 
 */
#import "GVCXMLGenericNode.h"
#import "GVCXMLParserDelegate.h"
#import "GVCXMLParsingModel.h"

/* 
 * XML digest 
 */
#import "GVCXMLDigestSetChildForAttributeKeyRule.h"
#import "GVCXMLDigester.h"
#import "GVCXMLDigesterAttributeMapRule.h"
#import "GVCXMLDigesterCreateObjectRule.h"
#import "GVCXMLDigesterElementNamePropertyRule.h"
#import "GVCXMLDigesterPairAttributeTextRule.h"
#import "GVCXMLDigesterRule.h"
#import "GVCXMLDigesterRuleManager.h"
#import "GVCXMLDigesterRuleset.h"
#import "GVCXMLDigesterSetChildRule.h"
#import "GVCXMLDigesterSetPropertyRule.h"
#import "GVCXMLDigesterSetTextPropertyFromAttributeValueRule.h"

/* 
 * XML generator 
 */
#import "GVCXMLGenerator.h"
#import "GVCXMLOutputNode.h"

/* 
 * XML node 
 */
#import "GVCXMLAttribute.h"
#import "GVCXMLComment.h"
#import "GVCXMLContainerNode.h"
#import "GVCXMLDocType.h"
#import "GVCXMLDocument.h"
#import "GVCXMLNamespace.h"
#import "GVCXMLNode.h"
#import "GVCXMLParseNodeDelegate.h"
#import "GVCXMLProcessingInstructions.h"
#import "GVCXMLText.h"

/* 
 * XML rss 
 */
#import "GVCRSSDigester.h"
#import "GVCRSSEntry.h"
#import "GVCRSSFeed.h"
#import "GVCRSSLink.h"
#import "GVCRSSNode.h"
#import "GVCRSSText.h"

/* 
 * formatter 
 */
#import "GVCISO8601DateFormatter.h"

#endif // GVCFoundation_h
