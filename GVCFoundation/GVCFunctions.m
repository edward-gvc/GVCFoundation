//
//  GVCFunctions.m
//  GVCFoundation
//
//  Created by David Aspinall on 11-09-30.
//  Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCFunctions.h"
#import <objc/runtime.h>


/* 
 * taken from an example at http://www.cocoadev.com/index.pl?MethodSwizzling
 */
void gcv_SwizzleClassMethod(Class c, SEL orig, SEL new) 
{
	
    Method origMethod = class_getClassMethod(c, orig);
    Method newMethod = class_getClassMethod(c, new);
	
    c = object_getClass((id)c);
	
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}


/* 
 * taken from an example at http://www.cocoadev.com/index.pl?MethodSwizzling
 */
void gcv_SwizzleInstanceMethod(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
		method_exchangeImplementations(origMethod, newMethod);
}


#pragma mark - Collection Functions
BOOL gcv_IsEqualCollection(id collectionA, id collectionB)
{
	BOOL isEqual = NO;
	
		// test they are same type of object
	if ( strcmp(@encode(__typeof__(collectionA)), @encode(__typeof__(collectionB))) == 0 )
	{
			// are they same instance
		if (collectionA == collectionB)
		{
			isEqual = YES;
		}
		else if (([collectionA respondsToSelector:@selector(count)] == YES) && ([collectionB respondsToSelector:@selector(count)] == YES))
		{
				// does collection size match
			if ([collectionA count] == [collectionB count])
			{
					// check each object in collection looking for failure
				isEqual = YES;
				for ( int idx = 0; isEqual && idx < [collectionA count]; idx++ )
				{
					isEqual = [[collectionA objectAtIndex:idx] isEqual:[collectionB objectAtIndex:idx]];
				}
			}
		}
	}
	return isEqual;
}
