/*
 * GVCLogger.m
 * 
 * Created by David Aspinall on 11-11-25. 
 * Copyright (c) 2011 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCLogger.h"
#import "NSString+GVCFoundation.h"
#import "GVCFunctions.h"

GVC_DEFINE_STRVALUE(GVC_DEBUG,	DEBUG);
GVC_DEFINE_STRVALUE(GVC_INFO,	INFO);
GVC_DEFINE_STRVALUE(GVC_WARNING,WARNING);
GVC_DEFINE_STRVALUE(GVC_ERROR,	ERROR);

#define GVCLOG_QUEUE_SIZE 1000

/**
 All non-ERROR leg messages are enqueued using GCD
 */
static dispatch_queue_t queue;

/**
 GCD Semaphore to ensure the queue does not get overwhelmed
 */
static dispatch_semaphore_t semaphore;


@interface GVCLogger()
+ (void)applicationWillTerminate:(NSNotification *)notification;
- (void)flushQueue;
- (void)writeMessage:(GVCLogMessage *)message;
- (void)enqueue:(GVCLogMessage *)message;
@end

@interface NSLogWriter : NSObject <GVCLogWriter>
@end

@implementation NSLogWriter
- (void)log:(GVCLogMessage *)msg
{
    printf("%s\n", [[[msg description] stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"] UTF8String]);
//    NSLog( @"%@", msg );
}
@end

@implementation GVCLogger

/**
 Again we use GCD to ensure the intialize is only called once
 */
+ (void)initialize
{
    static dispatch_once_t initializeDispatch;
    dispatch_once(&initializeDispatch, ^{

		queue = dispatch_queue_create("net.global_village.GVCLogger", NULL);
		semaphore = dispatch_semaphore_create(GVCLOG_QUEUE_SIZE);

#if TARGET_OS_IPHONE
		NSString *notificationName = @"UIApplicationWillTerminateNotification";
#else
		NSString *notificationName = @"NSApplicationWillTerminateNotification";
#endif
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:notificationName object:nil];
	});
}

+ (void)applicationWillTerminate:(NSNotification *)notification
{
	[[GVCLogger sharedGVCLogger] flushQueue];
}

@synthesize writer;
@synthesize loggerLevel;

GVC_SINGLETON_CLASS(GVCLogger)

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
        [self setLoggerLevel:GVCLoggerLevel_DEBUG];
        [self setWriter:[[NSLogWriter alloc] init]];
	}
	
    return self;
}

- (NSString *)stringForLevel:(GVCLoggerLevel)level
{
	GVC_ASSERT(level > GVCLoggerLevel_OFF && level <= GVCLoggerLevel_INFO, @"Invalid log level [%d]", level);
    
	NSString *strLevel = GVC_DEBUG;
	switch (level)
	{
		case GVCLoggerLevel_INFO:
			strLevel = GVC_INFO;
			break;
		case GVCLoggerLevel_WARNING:
			strLevel = GVC_WARNING;
			break;
		case GVCLoggerLevel_ERROR:
			strLevel = GVC_ERROR;
			break;
			
		case GVCLoggerLevel_DEBUG:
		default:
			break;
	}
	return strLevel;
}

- (BOOL)isLevelActive:(GVCLoggerLevel)level
{
	GVC_ASSERT(level > GVCLoggerLevel_OFF && level <= GVCLoggerLevel_INFO, @"Invalid log level [%d]", level);
    
    // error level logs ALWAYS are active
	return (level == GVCLoggerLevel_ERROR) || (loggerLevel >= level );
}

- (GVCLoggerLevel)loggerLevel
{
	return loggerLevel;
}

- (void)setLoggerLevel:(GVCLoggerLevel)level
{
	GVC_ASSERT(level >= GVCLoggerLevel_OFF, @"Log level must be greater than GVCLoggerLevel_OFF");
	GVC_ASSERT(level <= GVCLoggerLevel_INFO, @"Log level must be less than GVCLoggerLevel_INFO");
	
	if ((level >= GVCLoggerLevel_OFF) && (level <= GVCLoggerLevel_INFO))
		loggerLevel = level;
}

- (void)flushQueue
{
    // making this synchronous ensures the queue is cleared 
    dispatch_sync( queue, ^{ 
		// tell the log writer to flush
	});
}

- (void)writeMessage:(GVCLogMessage *)message
{
    if ( writer == nil )
    {
        [self setWriter:[[NSLogWriter alloc] init]];
    }
    [writer log:message];
    
    // GCD counting semaphore is incremented each time a message is written
    dispatch_semaphore_signal( semaphore );
}

- (void)enqueue:(GVCLogMessage *)message
{
    // GCD counting semaphore is decremented each time a message is enqueued, if it hits zero then
    // we block waiting for the queue to clear some messages
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    // this is the GCD block that is enqueued
	dispatch_block_t loggerBlock = ^{ 
		[self writeMessage:message];
	};
	
    // ERROR messages are processed synchronously
	if ([message level] > GVCLoggerLevel_ERROR )
    {
        dispatch_async( queue, loggerBlock );
    }
	else
    {
        dispatch_sync( queue, loggerBlock );
    }
}

-(void)log:(GVCLoggerLevel)level file:(char*)filename lineNumber:(int)lineNumber message:(NSString*)fmt,...
{
	GVC_ASSERT(level > GVCLoggerLevel_OFF && level <= GVCLoggerLevel_INFO, @"Invalid log level [%d]", level);
    GVC_ASSERT(filename != nil, @"No Filename for log");
    GVC_ASSERT(fmt != nil, @"No message" );
	
	if ( [self isLevelActive:level] == true )
	{
        va_list args;
        va_start(args, fmt);
        NSString *message = [[NSString alloc] initWithFormat:fmt arguments:args];
        va_end(args);

        [self enqueue:[[GVCLogMessage alloc] initLevel:level file:filename function:NULL line:lineNumber message:message]];
	}
}

-(void)log:(GVCLoggerLevel)level file:(char*)filename lineNumber:(int)lineNumber forError:(NSError*)err
{
	GVC_ASSERT(level > GVCLoggerLevel_OFF && level <= GVCLoggerLevel_INFO, @"Invalid log level [%d]", level);
    GVC_ASSERT(filename != nil, @"No Filename for log");
    GVC_ASSERT(err != nil, @"No error object" );
	
	if ( [self isLevelActive:level] == true )
	{
        [self enqueue:[[GVCLogMessage alloc] initLevel:level file:filename function:NULL line:lineNumber message:[err description]]];
	}
}

-(void)log:(GVCLoggerLevel)level file:(char*)filename lineNumber:(int)lineNumber functionName:(const char *)functionName message:(NSString*)fmt,...
{
	GVC_ASSERT(level > GVCLoggerLevel_OFF && level <= GVCLoggerLevel_INFO, @"Invalid log level [%d]", level);
    GVC_ASSERT(filename != nil, @"No Filename for log");
    GVC_ASSERT(fmt != nil, @"No message" );
	
	if ( [self isLevelActive:level] == true )
	{
        va_list args;
        va_start(args, fmt);
        NSString *message = [[NSString alloc] initWithFormat:fmt arguments:args];
        va_end(args);

        [self enqueue:[[GVCLogMessage alloc] initLevel:level file:filename function:functionName line:lineNumber message:message]];
	}
}
-(void)log:(GVCLoggerLevel)level file:(char*)filename lineNumber:(int)lineNumber functionName:(const char *)functionName forError:(NSError*)err
{
	GVC_ASSERT(level > GVCLoggerLevel_OFF && level <= GVCLoggerLevel_INFO, @"Invalid log level [%d]", level);
    GVC_ASSERT(filename != nil, @"No Filename for log");
    GVC_ASSERT(err != nil, @"No error object" );
	
	if ( [self isLevelActive:level] == true )
	{
        [self enqueue:[[GVCLogMessage alloc] initLevel:level file:filename function:functionName line:lineNumber message:[err description]]];
	}
}

@end

@implementation GVCLogMessage

@synthesize level;
@synthesize message;
@synthesize timestamp;
@synthesize file;
@synthesize function;
@synthesize lineNumber;

- (id)initLevel:(GVCLoggerLevel)lvl file:(const char *)afile function:(const char *)afunction line:(int)line message:(NSString *)msg
{
	self = [super init];
	if ( self != nil )
	{
        [self setLevel:lvl];
        [self setFile:afile];
        [self setFunction:afunction];
        [self setLineNumber:line];
        [self setMessage:msg];
	}
	
    return self;
}

- (NSString *)filename
{
    return (file != NULL ? [[NSString stringWithUTF8String:file] lastPathComponent] : [NSString gvc_EmptyString]);
}

- (NSString *)functionName
{
    return (function != NULL ? [NSString stringWithUTF8String:function] : [NSString gvc_EmptyString]);
}

- (NSString *)description
{
    return GVC_SPRINTF(@"[%@] %@:%d %@ %@\n", [[GVCLogger sharedGVCLogger] stringForLevel:level], [self filename], lineNumber, [self functionName], message);
}

@end
