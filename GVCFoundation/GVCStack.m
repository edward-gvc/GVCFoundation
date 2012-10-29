//
//  GVCStack.h
//
//  Created by David Aspinall on 10-02-03.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCStack.h"
#import "GVCMacros.h"
#import "GVCFunctions.h"

@interface GVCStack ()
@property (strong, nonatomic) NSMutableArray *internStore;
@end

@implementation GVCStack

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
		[self setInternStore:[[NSMutableArray alloc] init]];
	}
	
    return self;
}


- (id)initWithObject:(id)anObject
{
	self = [self init];
	if ( self != nil )
	{
        [self pushObject:anObject];
	}
	
    return self;
}


- (void)pushObject:(id)anObject
{
	if ( anObject != nil )
	{
		[[self internStore] addObject:anObject];
	}
}

- (void)pushObjects:(id)object,...
{
	if (object != nil)
    {
        id obj = object;
        va_list objects;
        va_start(objects, object);
        do 
        {
            [self pushObject:obj];
            obj = va_arg(objects, id);
        } while (obj);
        va_end(objects);
    }
}

- (id)popObject
{
	id popValue = nil;
    if ([[self internStore] count] > 0)
	{
		popValue = [[self internStore] lastObject];
		[[self internStore] removeLastObject];
	}
	return popValue;
}

- (id)peekObject
{
	id peekValue = nil;
    if ([[self internStore] count] > 0)
	{
		peekValue = [[self internStore] lastObject];
	}
	return peekValue;
}

/** assumes the user wants the index from the top of the stack down to the bottom */
- (id)peekObjectAtIndex:(NSUInteger)idx
{
	id peekValue = nil;
	NSInteger depth = (NSInteger)[[self internStore] count] - 1;
	NSInteger target = (NSInteger)(depth - (NSInteger)idx);
	
    if ((target >= 0) && (target < (NSInteger)[[self internStore] count]))
	{
		peekValue = [[self internStore] objectAtIndex:(NSUInteger)target];
	}

	return peekValue;
}


- (void)clear
{
    [[self internStore] removeAllObjects];
}


- (id)topObject
{
    return [[self internStore] lastObject];
}

- (NSArray *)topObjects:(NSUInteger)count
{
    return [[self internStore] subarrayWithRange:NSMakeRange([[self internStore] count] - count , count)];
}

- (NSArray *)allObjects
{
    return [[self internStore] copy];
}

- (NSUInteger)count
{
    return [[self internStore] count];
}

- (NSString *)description
{
	return [[self internStore] description];
}

- (BOOL)isEmpty
{
	return gvc_IsEmpty([self internStore]);
}


@end
