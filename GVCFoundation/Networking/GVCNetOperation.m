
#import "GVCNetOperation.h"

GVC_DEFINE_STR( GVCNetOperationErrorDomain )

@interface GVCNetOperation ()


// Internal properties

enum {
    kQHTTPOperationStateInited, 
    kQHTTPOperationStateExecuting, 
    kQHTTPOperationStateFinished
};

@property (assign, nonatomic) NSInteger             state;
@property (retain, nonatomic) NSURLConnection *     connection;
@property (assign, nonatomic) BOOL                  firstData;
@property (retain, nonatomic) NSMutableData *       dataAccumulator;

@end

@implementation GVCNetOperation

@synthesize request;
@synthesize authenticationDelegate;
@synthesize acceptableStatusCodes;
@synthesize acceptableContentTypes;
@synthesize responseOutputStream;
@synthesize defaultResponseSize;
@synthesize maximumResponseSize;
@synthesize lastRequest;
@synthesize lastResponse;
@synthesize responseBody;
@synthesize connection;
@synthesize firstData;
@synthesize dataAccumulator;
@synthesize state;

#pragma mark * Initialise and finalise

- (id)initWithDelegate:(NSObject <GVCOperationDelegate> *)del forRequest:(NSURLRequest *)req
{
    // any thread
    GVC_ASSERT(req != nil, @"No request");
    GVC_ASSERT(([req URL] != nil), @"NO Request URL");
    // Because we require an NSHTTPURLResponse, we only support HTTP and HTTPS URLs.
	
	NSString *scheme = [[[req URL] scheme] lowercaseString];
    GVC_ASSERT([scheme isEqual:@"http"] || [scheme isEqual:@"https"], @"Invalid scheme [%@]", scheme );
	
    self = [super initWithDelegate:del];
    if (self != nil) 
	{
        #if TARGET_OS_EMBEDDED || TARGET_IPHONE_SIMULATOR
            static const NSUInteger kPlatformReductionFactor = 4;
        #else
            static const NSUInteger kPlatformReductionFactor = 1;
        #endif

        request = [req copy];
        [self setDefaultResponseSize:1 * 1024 * 1024 / kPlatformReductionFactor];
        [self setMaximumResponseSize:4 * 1024 * 1024 / kPlatformReductionFactor];
        [self setFirstData:YES];
		//self.state = kQHTTPOperationStateInited;
    }
    return self;
}

- (id)initWithDelegate:(id)del forURL:(NSURL *)url;
{
    GVC_ASSERT(url != nil, @"No URL");
    return [self initWithDelegate:del forRequest:[NSURLRequest requestWithURL:url]];
}

- (GVCOperationType)operationType
{
	return GVCOperationType_NETWORK;
}

- (void)stopConnection
{
    GVC_ASSERT([self isRunLoopThread], @"Not on run loop thread");
	
    [[self connection] cancel];
    GVC_NILRELEASE( connection );
	
    if (self.responseOutputStream != nil) 
	{
        [self.responseOutputStream close];
    }
	
    [self setState:kQHTTPOperationStateFinished];
}

- (void)dealloc
{
    GVC_ASSERT(connection == nil, @"Connection should already be closed");               // should have been shut down by now
	GVC_NILRELEASE(request);
	GVC_NILRELEASE(acceptableStatusCodes);
	GVC_NILRELEASE(acceptableContentTypes);
	GVC_NILRELEASE(responseOutputStream);
	GVC_NILRELEASE(dataAccumulator);
	GVC_NILRELEASE(lastRequest);
	GVC_NILRELEASE(lastResponse);
	GVC_NILRELEASE(responseBody);
	[super dealloc];
}

#pragma mark * Properties

// We write our own settings for many properties because we want to bounce 
// sets that occur in the wrong state.  And, given that we've written the 
// setter anyway, we also avoid KVO notifications when the value doesn't change.


+ (BOOL)automaticallyNotifiesObserversOfRunLoopThread
{
    return NO;
}


+ (BOOL)automaticallyNotifiesObserversOfAuthenticationDelegate
{
    return NO;
}

- (void)setAuthenticationDelegate:(id<GVCNetOperationAuthenticationDelegate>)newValue
{
    if ([self state] != kQHTTPOperationStateInited) 
	{
        GVC_ASSERT(NO, @"Cannot change auth delegate after process started");
    }
	else 
	{
        if (newValue != authenticationDelegate) 
		{
            [self willChangeValueForKey:@"authenticationDelegate"];
            authenticationDelegate = newValue;
            [self didChangeValueForKey:@"authenticationDelegate"];
        }
    }
}



+ (BOOL)automaticallyNotifiesObserversOfAcceptableStatusCodes
{
    return NO;
}

- (void)setAcceptableStatusCodes:(NSIndexSet *)newValue
{
    if ([self state] != kQHTTPOperationStateInited) 
	{
        GVC_ASSERT(NO, @"Cannot change after operation started" );
    }
	else
	{
        if (newValue != acceptableStatusCodes) 
		{
            [self willChangeValueForKey:@"acceptableStatusCodes"];
            [acceptableStatusCodes autorelease];
            acceptableStatusCodes = [newValue copy];
            [self didChangeValueForKey:@"acceptableStatusCodes"];
        }
    }
}



+ (BOOL)automaticallyNotifiesObserversOfAcceptableContentTypes
{
    return NO;
}

- (void)setAcceptableContentTypes:(NSSet *)newValue
{
	if (newValue != acceptableContentTypes) 
	{
		[self willChangeValueForKey:@"acceptableContentTypes"];
		[acceptableContentTypes autorelease];
		acceptableContentTypes = [newValue copy];
		[self didChangeValueForKey:@"acceptableContentTypes"];
	}
}

+ (BOOL)automaticallyNotifiesObserversOfResponseOutputStream
{
    return NO;
}

- (void)setResponseOutputStream:(NSOutputStream *)newValue
{
    if (dataAccumulator != nil) 
	{
        GVC_ASSERT(NO, @"Cannot change after operation started" );
    }
	else 
	{
        if (newValue != responseOutputStream) 
		{
            [self willChangeValueForKey:@"responseOutputStream"];
            [responseOutputStream autorelease];
            responseOutputStream = [newValue retain];
            [self didChangeValueForKey:@"responseOutputStream"];
        }
    }
}


+ (BOOL)automaticallyNotifiesObserversOfDefaultResponseSize
{
    return NO;
}

- (void)setDefaultResponseSize:(NSUInteger)newValue
{
    if (dataAccumulator != nil) 
	{
        GVC_ASSERT(NO, @"Cannot change after operation started" );
    }
	else 
	{
        if (newValue != defaultResponseSize) 
		{
            [self willChangeValueForKey:@"defaultResponseSize"];
            defaultResponseSize = newValue;
            [self didChangeValueForKey:@"defaultResponseSize"];
        }
    }
}


+ (BOOL)automaticallyNotifiesObserversOfMaximumResponseSize
{
    return NO;
}

- (void)setMaximumResponseSize:(NSUInteger)newValue
{
    if (dataAccumulator != nil) 
	{
        GVC_ASSERT(NO, @"Cannot change after operation started" );
    } 
	else 
	{
        if (newValue != maximumResponseSize) 
		{
            [self willChangeValueForKey:@"maximumResponseSize"];
            maximumResponseSize = newValue;
            [self didChangeValueForKey:@"maximumResponseSize"];
        }
    }
}

- (BOOL)isStatusCodeAcceptable
{
    NSIndexSet *    acceptStatusCodes;
    NSInteger       statusCode;
    
    GVC_ASSERT(self.lastResponse != nil, @"Final response not set" );
    
    acceptStatusCodes = [self acceptableStatusCodes];
    if (acceptStatusCodes == nil) 
	{
        acceptStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
    }
	GVC_ASSERT(acceptStatusCodes != nil, @"No acceptable status codes" );
    
    statusCode = [[self lastResponse] statusCode];
    return (statusCode >= 0) && [acceptStatusCodes containsIndex: (NSUInteger) statusCode];
}

- (BOOL)isContentTypeAcceptable
{
    NSString *  contentType;
    
	GVC_ASSERT([self lastResponse] != nil, @"Final response not set");
    contentType = [[self lastResponse] MIMEType];
    return ([self acceptableContentTypes] == nil) || ((contentType != nil) && [[self acceptableContentTypes] containsObject:contentType]);
}

#pragma mark * Core state transitions

- (void)setState:(NSInteger)newState
{
    // any thread

    @synchronized (self) 
	{
        NSInteger   oldState = [self state];
        
        GVC_ASSERT(newState > oldState, @"Cannot move state backwards");

        // inited    + executing -> isExecuting
        // inited    + finished  -> isFinished
        // executing + finished  -> isExecuting + isFinished
        
        if ((newState == kQHTTPOperationStateExecuting) || (oldState == kQHTTPOperationStateExecuting))
		{
            [self willChangeValueForKey:@"isExecuting"];
        }
		
        if (newState == kQHTTPOperationStateFinished) 
		{
            [self willChangeValueForKey:@"isFinished"];
        }
        
		state = newState;
        
		if (newState == kQHTTPOperationStateFinished) 
		{
            [self didChangeValueForKey:@"isFinished"];
        }
        if ((newState == kQHTTPOperationStateExecuting) || (oldState == kQHTTPOperationStateExecuting) ) 
		{
            [self didChangeValueForKey:@"isExecuting"];
        }
    }
}

// An internal routine called to shut down the actual connection, do 
// various bits of important tidying up, and change the operation state 
// to finished.
- (void)failWithError:(NSError *)err
{
    GVC_ASSERT([self isRunLoopThread], @"Not on runLoop thread" );
	[self stopConnection];
    [super failWithError:err];
}

// Starts the operation.  The actual -start method is very simple, 
// deferring all of the work to be done on the run loop thread by this 
// method.
- (void)startOnRunLoopThread
{
    GVC_ASSERT([self isRunLoopThread], @"Not on run loop thread");
    
    GVC_ASSERT(self.defaultResponseSize > 0, @"defaultResponseSize not set" );
    GVC_ASSERT(self.maximumResponseSize > 0, @"maxResponseSize not set" );
    GVC_ASSERT(self.defaultResponseSize <= self.maximumResponseSize, @"defaultResponseSize > maxResponseSize %d <= %d", self.defaultResponseSize, self.maximumResponseSize);
    
    GVC_ASSERT([self request] != nil, @"No request" );
    GVC_ASSERT([self connection] == nil, @"Connection already set");
	
    if ([self isCancelled]) 
	{
        [self failWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
    }
	else if ([[[[self.request URL] scheme] lowercaseString] isEqual:@"http"] || [[[[self.request URL] scheme] lowercaseString] isEqual:@"https"])
	{
		if ( self.state < kQHTTPOperationStateExecuting )
			self.state = kQHTTPOperationStateExecuting;
		
        [self setConnection:[NSURLConnection connectionWithRequest:self.request delegate:self]];
    }
	else
	{
		[self failWithError:[NSError errorWithDomain:@"DANetOperation" code:500 localizedDescription:GVCLocalizedFormat(@"Bad Scheme %@", [[self.request URL] scheme])]];
	}
}

- (void)cancelOnRunLoopThread
{
	[super cancelOnRunLoopThread];

	if ([self connection] != nil) 
	{
		[self failWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
	}
}

#pragma mark * NSURLConnection delegate callbacks

- (BOOL)connection:(NSURLConnection *)cnx canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
    // See comment in header.
{
    BOOL    result;
    
    GVC_ASSERT([self isRunLoopThread], @"Not on run loop thread" );
    GVC_ASSERT(cnx == [self connection], @"Not this connection");
    #pragma unused(cnx)
    GVC_ASSERT(protectionSpace != nil, @"No protection space");
    #pragma unused(protectionSpace)
    
    result = NO;
    if (self.authenticationDelegate != nil) 
	{
        result = [self.authenticationDelegate httpOperation:self canAuthenticateAgainstProtectionSpace:protectionSpace];
    }
    return result;
}

- (void)connection:(NSURLConnection *)cnx didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
    // See comment in header.
{
    GVC_ASSERT([self isRunLoopThread], @"Not on run loop thread" );
    GVC_ASSERT(cnx == [self connection], @"Not this connection");
    #pragma unused(cnx)
    GVC_ASSERT(challenge != nil, @"No authentication challenge");
    #pragma unused(challenge)
    
    if (self.authenticationDelegate != nil) {
        [self.authenticationDelegate httpOperation:self didReceiveAuthenticationChallenge:challenge];
    } else {
        if ( [challenge previousFailureCount] == 0 ) {
            [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
        } else {
            [[challenge sender] cancelAuthenticationChallenge:challenge];
        }
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)cnx willSendRequest:(NSURLRequest *)req redirectResponse:(NSURLResponse *)response
    // See comment in header.
{
    GVC_ASSERT([self isRunLoopThread], @"Not on run loop thread" );
    GVC_ASSERT(cnx == [self connection], @"Not this connection");
    #pragma unused(cnx)
    GVC_ASSERT( (response == nil) || [response isKindOfClass:[NSHTTPURLResponse class]], @"No response class" );

    self.lastRequest  = req;
    self.lastResponse = (NSHTTPURLResponse *) response;
    return req;
}

- (void)connection:(NSURLConnection *)cnx didReceiveResponse:(NSURLResponse *)response
    // See comment in header.
{
    GVC_ASSERT([self isRunLoopThread], @"Not on run loop thread" );
    GVC_ASSERT(cnx == [self connection], @"Not this connection");
    #pragma unused(cnx)
    GVC_ASSERT([response isKindOfClass:[NSHTTPURLResponse class]], @"Not a NSHTTPURLResponse");

    self.lastResponse = (NSHTTPURLResponse *) response;
    
    // We don't check the status code here because we want to give the client an opportunity 
    // to get the data of the error message.  Perhaps we /should/ check the content type 
    // here, but I'm not sure whether that's the right thing to do.
}

- (void)connection:(NSURLConnection *)cnx didReceiveData:(NSData *)data
    // See comment in header.
{
    BOOL    success;
    
    GVC_ASSERT([self isRunLoopThread], @"Not on run loop thread" );
    GVC_ASSERT(cnx == [self connection], @"Not this connection");
    #pragma unused(cnx)
    GVC_ASSERT(data != nil, @"No data");
    
    // If we don't yet have a destination for the data, calculate one.  Note that, even 
    // if there is an output stream, we don't use it for error responses.
    
    success = YES;
    if (self.firstData) 
	{
        GVC_ASSERT(self.dataAccumulator == nil, @"Data Accumulatot already set");
        
        if ( (self.responseOutputStream == nil) || ! self.isStatusCodeAcceptable ) 
		{
            long long   length = [self.lastResponse expectedContentLength];
            if (length == NSURLResponseUnknownLength) 
			{
                length = self.defaultResponseSize;
            }
            if (length <= (long long) self.maximumResponseSize) {
                self.dataAccumulator = [NSMutableData dataWithCapacity:(NSUInteger)length];
            } else {
                [self failWithError:[NSError errorWithDomain:GVCNetOperationErrorDomain code:kQHTTPOperationErrorResponseTooLarge userInfo:nil]];
                success = NO;
            }
        }
        
        // If the data is going to an output stream, open it.
        
        if (success) 
		{
            if (self.dataAccumulator == nil) 
			{
                GVC_ASSERT(self.responseOutputStream != nil, @"no reponse");
                [self.responseOutputStream open];
            }
        }
        
        self.firstData = NO;
    }
    
    // Write the data to its destination.

    if (success) {
        if (self.dataAccumulator != nil) {
            if ( ([self.dataAccumulator length] + [data length]) <= self.maximumResponseSize ) {
                [self.dataAccumulator appendData:data];
            } else {
                [self failWithError:[NSError errorWithDomain:GVCNetOperationErrorDomain code:kQHTTPOperationErrorResponseTooLarge userInfo:nil]];
            }
        } else {
            NSUInteger      dataOffset;
            NSUInteger      dataLength;
            const uint8_t * dataPtr;
            NSError *       err;
            NSInteger       bytesWritten;

            GVC_ASSERT(self.responseOutputStream != nil, @"No response");

            dataOffset = 0;
            dataLength = [data length];
            dataPtr    = [data bytes];
            err      = nil;
            do {
                if (dataOffset == dataLength) {
                    break;
                }
                bytesWritten = [self.responseOutputStream write:&dataPtr[dataOffset] maxLength:dataLength - dataOffset];
                if (bytesWritten <= 0) {
                    err = [self.responseOutputStream streamError];
                    if (err == nil) {
                        err = [NSError errorWithDomain:GVCNetOperationErrorDomain code:kQHTTPOperationErrorOnOutputStream userInfo:nil];
                    }
                    break;
                } else {
                    dataOffset += bytesWritten;
                }
            } while (YES);
            
            if (err != nil) 
			{
                [self failWithError:err];
            }
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)cnx
    // See comment in header.
{
    GVC_ASSERT([self isRunLoopThread], @"Not on run loop thread" );
    GVC_ASSERT(cnx == [self connection], @"Not this connection");
    #pragma unused(cnx)
    
    GVC_ASSERT(self.lastResponse != nil, @"Final response not set");

    // Swap the data accumulator over to the response data so that we don't trigger a copy.
    
    GVC_ASSERT(responseBody == nil, @"No response body");
    responseBody = dataAccumulator;
    dataAccumulator = nil;
    
    if ( ! self.isStatusCodeAcceptable ) 
	{
        [self failWithError:[NSError errorWithDomain:GVCNetOperationErrorDomain code:self.lastResponse.statusCode userInfo:nil]];
    }
	else if ( ! self.isContentTypeAcceptable ) 
	{
        [self failWithError:[NSError errorWithDomain:GVCNetOperationErrorDomain code:kQHTTPOperationErrorBadContentType userInfo:nil]];
    }
	else 
	{
		[self stopConnection];
		[self operationFinished];
    }
}

- (void)connection:(NSURLConnection *)cnx didFailWithError:(NSError *)err
    // See comment in header.
{
    GVC_ASSERT([self isRunLoopThread], @"Not on run loop thread" );
    GVC_ASSERT(cnx == [self connection], @"Not this connection");
    #pragma unused(cnx)
    GVC_ASSERT(err != nil, @"Failed with no error set");

    [self failWithError:err];
}

#pragma mark * Overrides

- (BOOL)isExecuting
{
    // any thread
    return self.state == kQHTTPOperationStateExecuting;
}
 
- (BOOL)isFinished
{
    // any thread
    return self.state == kQHTTPOperationStateFinished;
}


//- (void)cancel
//{
//    // any thread
//    [self performSelector:@selector(cancelOnRunLoopThread) onThread:[self actualRunLoopThread] withObject:nil waitUntilDone:YES];
//}

@end
