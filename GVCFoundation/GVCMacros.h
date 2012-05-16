//
//  GVCMacros.h
//  GVCFoundation
//
//  Created by David Aspinall on 11-09-28.
//  Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
//

#ifndef GVCFoundation_GVCMacros_h
#define GVCFoundation_GVCMacros_h

#pragma mark - External Defines
#ifndef GVC_EXTERN
    #define GVC_EXTERN  extern
#endif


#ifndef GVC_PRIVATE_EXTERN
    #define GVC_PRIVATE_EXTERN	__private_extern__
#endif

#pragma mark - char constants
#define GVC_DOMAIN_SEPARATOR ((char)'/')

#pragma mark - key generation
// create an domain key @"dom/key" example @"OtherClass/My Format %d"
#define GVC_DOMAIN_KEY(dom, key)        GVC_SPRINTF(@"%@%c%@", ((dom)), GVC_DOMAIN_SEPARATOR, ((key)))

// create an domain key for the indicated object example @"MyCoreDataEO/MyAttribute"
#define GVC_OBJ_DOMAIN_KEY(obj, key)	GVC_SPRINTF(@"%@%c%@", GVC_CLASSNAME(obj), GVC_DOMAIN_SEPARATOR, ((key)))
#define GVC_CLS_DOMAIN_KEY(key)         GVC_SPRINTF(@"%@%c%@", GVC_CLASSNAME(self), GVC_DOMAIN_SEPARATOR, ((key)))

#pragma mark - Singletons

/** header definition */
#define GVC_SINGLETON_HEADER(classname)	\
+ (classname *)shared##classname; \
- (id)sharedDoOnceInit;


/** class implementation */
#define GVC_SINGLETON_CLASS(classname) \
static classname *shared##classname = nil; \
+ (classname *)shared##classname \
{ \
	static dispatch_once_t sharedDispatch;  \
	dispatch_once(&sharedDispatch, ^{ shared##classname = [[self alloc] init]; }); \
	return shared##classname; \
} \
+ (id)allocWithZone:(NSZone *)zone \
{ \
	static dispatch_once_t sharedAlloc; \
	dispatch_once(&sharedAlloc, ^{ \
		shared##classname = [super allocWithZone:zone]; \
		gcv_SwizzleInstanceMethod([shared##classname class], @selector(init), @selector(sharedDoOnceInit)); \
	}); \
	return shared##classname; \
} \
- (id)sharedDoOnceInit \
{ \
	static dispatch_once_t sharedInit; \
	dispatch_once(&sharedInit, ^{ shared##classname = [shared##classname sharedDoOnceInit]; }); \
	return shared##classname; \
}

#pragma mark - Defined Constant Strings

/*
 * An easy way to define string constants. 
 */
#define GVC_DEFINE_STRVALUE(name,value)		NSString * const name = @#value;
#define GVC_DEFINE_STR(name)                GVC_DEFINE_STRVALUE(name,name)
#define GVC_DEFINE_EXTERN_STR(name)			extern NSString * const name;

#pragma mark - String Macros

	// Class and file identification MACROs
#define	GVC_CLASSNAME(o)	NSStringFromClass([o class])
#define	GVC_FILEID          [NSString stringWithFormat:@"[%s:%d]", __FILE__,  __LINE__]

	// convenient macro to create a formatted string
#define GVC_SPRINTF(FORMAT, ... )  [NSString stringWithFormat:(FORMAT), ##__VA_ARGS__]


#pragma mark - Properties
/**	
 The following macro is for specifying property (ivar) names to KVC or KVO methods. These methods generally take strings, but strings don't get checked for typos by the compiler. If you write GVC_PROPERTY(badvalue) instead of GVC_PROPERTY(propname), the compiler will immediately complain that it doesn't know the selector 'badvalue', and thus point out the typo. For this to work, you need to make sure the warning -Wunknown-selector is on.
 
 Example:
 [myobject valueForKey:GVC_PROPERTY(myproperty)];
 */
#if DEBUG
	#define GVC_PROPERTY(propName)    NSStringFromSelector(@selector(propName))
#else
	#define GVC_PROPERTY(propName)    @#propName
#endif


#pragma mark - Assertions

#ifdef DEBUG
	#define GVC_ASSERT_LOG(...)		[[NSAssertionHandler currentHandler] \
		handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] \
		file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] \
		lineNumber:__LINE__ description:__VA_ARGS__]
#else
	#define GVC_ASSERT_LOG(...)		NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#endif

	// general purpose GVC Assert Macro
#define GVC_ASSERT(condition, ...)	do { if (!(condition)) { GVC_ASSERT_LOG(__VA_ARGS__); }} while(0)

    // convenient assert test for not nil
#define GVC_ASSERT_NOT_NIL(condition) \
do { if (condition == nil)	{ GVC_ASSERT_LOG(@"%@ is not allowed to be empty", @#condition); }} while(0)

	// convenient assert test for strings
#define GVC_ASSERT_VALID_STRING(strcond) \
	do { if ((strcond == nil || [(NSData *)strcond length] == 0))	{ GVC_ASSERT_LOG(@"%@ is not allowed to be empty", @#strcond); }} while(0)

	// this will Assert that subclass must implement this required method.  Despite this I disable in production code.
#define GVC_SUBCLASS_RESPONSIBLE	GVC_ASSERT_LOG( @"Subclasses %@ must implement %@", GVC_CLASSNAME(self), NSStringFromSelector(_cmd));


#endif
