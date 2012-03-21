
#import <Foundation/Foundation.h>
#import "GVCRunLoopOperation.h"


// positive error codes are HTML status codes (when they are not allowed via acceptableStatusCodes)
//
// 0 is, of course, not a valid error code
//
// negative error codes are errors from the module

enum {
    kQHTTPOperationErrorResponseTooLarge = -1, 
    kQHTTPOperationErrorOnOutputStream   = -2, 
    kQHTTPOperationErrorBadContentType   = -3
};

typedef enum 
{
    GVC_NetOperation_ErrorType_CONNECT_FAIL = 1,
    GVC_NetOperation_ErrorType_TIMED_OUT = 2,
    GVC_NetOperation_ErrorType_AUTHENTICATION = 3,
    GVC_NetOperation_ErrorType_REQUEST_CANCELLED = 4,
    GVC_NetOperation_ErrorType_UNABLE_TO_CREATE_REQUEST = 5,
    GVC_NetOperation_ErrorType_ERROR_BUILDING_REQUEST  = 6,
    GVC_NetOperation_ErrorType_INTERNAL_ERROR_CREDENTIALS  = 7,
	GVC_NetOperation_ErrorType_FILE_MANAGEMENT_ERROR = 8,
	GVC_NetOperation_ErrorType_TOO_MUCH_REDIRECTION = 9,
	GVC_NetOperation_ErrorType_UNHANDLED = 10
	
} GVC_NetOperation_ErrorType;

GVC_DEFINE_EXTERN_STR( GVCNetOperationErrorDomain )

@interface GVCNetOperation : GVCRunLoopOperation 

      // designated
- (id)initForRequest:(NSURLRequest *)request;
- (id)initForURL:(NSURL *)url;

// Things that are configured by the init method and can't be changed.

@property (copy, nonatomic)  NSURLRequest *        request;

// Things you can configure before queuing the operation.

@property (copy, nonatomic) NSIndexSet *          acceptableStatusCodes;  // default is nil, implying 200..299
@property (copy, nonatomic) NSSet *               acceptableContentTypes; // default is nil, implying anything is acceptable
@property (assign, nonatomic) id<GVCNetOperationAuthenticationDelegate>  authenticationDelegate;

// Things you can configure up to the point where you start receiving data.

@property (retain, nonatomic) NSOutputStream *      responseOutputStream;   // defaults to nil, which puts response into responseBody
@property (assign, nonatomic) NSUInteger            defaultResponseSize;    // default is 1 MB, ignored if responseOutputStream is set
@property (assign, nonatomic) NSUInteger            maximumResponseSize;    // default is 4 MB, ignored if responseOutputStream is set
                                                                            // defaults are 1/4 of the above on embedded

// Things that are only meaningful after a response has been received;

@property (assign, readonly, nonatomic, getter=isStatusCodeAcceptable)  BOOL statusCodeAcceptable;
@property (assign, readonly, nonatomic, getter=isContentTypeAcceptable) BOOL contentTypeAcceptable;


@property (copy, nonatomic)  NSURLRequest *        lastRequest;       
@property (copy, nonatomic)  NSHTTPURLResponse *   lastResponse;       

@property (copy, nonatomic)  NSData *              responseBody;   

@end


@interface GVCNetOperation (NSURLConnectionDelegate)

// QHTTPOperation implements all of these methods, so if you override them 
// you must consider whether or not to call super.
//
// These will be called on the operation's run loop thread.

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;
    // Routes the request to the authentication delegate if it exists, otherwise 
    // just returns NO.
    
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
    // Routes the request to the authentication delegate if it exists, otherwise 
    // just cancels the challenge.

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response;
    // Latches the request and response in lastRequest and lastResponse.
    
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
    // Latches the response in lastResponse.
    
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
    // If this is the first chunk of data, it decides whether the data is going to be 
    // routed to memory (responseBody) or a stream (responseOutputStream) and makes the 
    // appropriate preparations.  For this and subsequent data it then actually shuffles 
    // the data to its destination.
    
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
    // Completes the operation with either no error (if the response status code is acceptable) 
    // or an error otherwise.
    
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
    // Completes the operation with the error.

@end

@protocol GVCNetOperationAuthenticationDelegate <GVCOperationDelegate>
@required

// These are called on the operation's run loop thread and have the same semantics as their 
// NSURLConnection equivalents.  It's important to realise that there is no 
// didCancelAuthenticationChallenge callback (because NSURLConnection doesn't issue one to us).  
// Rather, an authentication delegate is expected to observe the operation and cancel itself 
// if the operation completes while the challenge is running.

- (BOOL)httpOperation:(GVCNetOperation *)operation canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;
- (void)httpOperation:(GVCNetOperation *)operation didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

@end

