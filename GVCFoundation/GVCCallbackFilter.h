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
	<li><PRE>[method.returns.array [method.on.array.item] [another.on.array.item]]</PRE> the filter will loop through the array repeatedly but will send the embedded kvc paths to the items in the array.  
	<li><PRE>[method.returns.condition some value]</PRE> the filter will only display the "some value" if the condition is a Number > 0 (ie boolean true, or [array count]
 */
@interface GVCCallbackFilter : NSObject
{
    UniChar startMarker;
	UniChar endMarker;
}

@property (retain,nonatomic) NSData *source;
@property (retain,nonatomic) NSObject <GVCWriter> *output;
@property (retain,nonatomic) NSObject *callback;

- (void)process;

@end
