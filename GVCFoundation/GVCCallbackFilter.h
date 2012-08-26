//
//  GVCCallbackParser.h
//
//  Created by David Aspinall on 11-03-29.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GVCReaderWriter.h"

/**
 * This is a very simple callback filter.  It reads from NSData and writes to a GVCWriter.  Each time it encounters an <PRE>[method.name.path]</PRE> it sends a value for key to the callback object and inserts the returned value into the output stream.  If the format is
	<PRE>[method.returns.array [method.on.array.item] [another.on.array.item]]</PRE> 
	the filter will loop through the array repeatedly but will send the embedded kvc paths to the items in the array
	<PRE>[method.returns.condition some value]</PRE> the filter will only display the "some value" if the condition is a Number > 0 (ie boolean true, or [array count]
 */
@interface GVCCallbackFilter : NSObject

/**
 * The start marker is the unicode char that indicates the beginning of a callback in the template.  By default this is '['.  An example callback: <pre>Today is [object.today.@format.YYYYMMDD]</pre>
 */
@property (assign, nonatomic) UniChar startMarker;

/**
 * The end marker is the unicode char that indicates the end of a callback in the template.  By default this is ']'.  An example callback: <pre>Today is [object.today.@format.YYYYMMDD]</pre>
 */
@property (assign, nonatomic) UniChar endMarker;

/**
 * source data contains the template content
 */
@property (strong,nonatomic) NSData *source;

/**
 * output destination
 */
@property (strong,nonatomic) NSObject <GVCWriter> *output;

/**
 * The callback object will be the target for the template kvc messages
 */
@property (strong,nonatomic) NSObject *callback;

- (void)process;

@end
