//
//  GVCParser.h
//
//  Created by David Aspinall on 10-12-06.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GVCParserDelegate;

@interface GVCParser : NSObject

@property (weak, nonatomic) id <GVCParserDelegate> delegate;
@property (readonly, strong, nonatomic) NSScanner *scanner;

@property (strong, nonatomic) NSString *fieldSeparator;
@property (strong, nonatomic) NSMutableArray *fieldNames;
@property (assign, nonatomic) BOOL separatorIsSingleChar;
@property (strong, nonatomic) NSCharacterSet *endTextCharacterSet;
@property (assign, nonatomic) BOOL cancelled;

- (id)initWithDelegate:(id <GVCParserDelegate>)del separator:(NSString *)aSep fieldNames:(NSArray *)names;

- (NSString *)fieldNameAtIndex:(NSInteger)idx;

- (BOOL)parseFilename:(NSString *)afile error:(NSError **)err;
- (BOOL)parseFilename:(NSString *)afile withEncoding:(NSStringEncoding)encode error:(NSError **)err;
- (BOOL)parseString:(NSString *)content error:(NSError **)err;

- (BOOL)performParse:(NSError **)err;
	
@end


@protocol GVCParserDelegate

- (void)parser:(GVCParser *)parser didStartFile:(NSString *)sourceFile;
- (void)parser:(GVCParser *)parser didParseRow:(NSDictionary *)dictRow;
- (void)parser:(GVCParser *)parser didEndFile:(NSString *)sourceFile;
- (void)parser:(GVCParser *)parser didFailWithError:(NSError *)anError;

@end
