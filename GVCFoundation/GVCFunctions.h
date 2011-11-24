//
//  GVCFunctions.h
//  GVCFoundation
//
//  Created by David Aspinall on 11-09-30.
//  Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
//

#ifndef _GVCFunctions_
#define _GVCFunctions_

#import <Foundation/NSString.h>
#import <Foundation/NSValue.h>
#import <Foundation/NSDictionary.h>

#import "GVCMacros.h"


void gcv_SwizzleClassMethod(Class c, SEL orig, SEL new);
void gcv_SwizzleInstanceMethod(Class c, SEL orig, SEL new);

#pragma mark - Collection Functions
BOOL gcv_IsEqualCollection(id collectionA, id collectionB);


#pragma mark - Empty or Nil test 

	// Credit: http://www.wilshipley.com/blog/2005/10/pimp-my-code-interlude-free-code.html
static inline BOOL gvc_IsEmpty(id thing) 
{
    return thing == nil	
		|| ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0)
		|| ([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0);
}


#endif // _GVCFunctions_
