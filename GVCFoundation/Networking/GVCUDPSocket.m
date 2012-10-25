//
//  GVCUDPSocket.m
//
//  Created by David Aspinall on 11-05-20.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCUDPSocket.h"

#import "GVCMacros.h"
#import "GVCLogger.h"

#include <netinet/in.h>
#include <unistd.h>

@interface GVCUDPSocket()
- (int)readData;
@end


static void SocketReadCallback(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
    // This C routine is called by CFSocket when there's data waiting on our 
    // UDP socket.  It just redirects the call to Objective-C code.
{
    GVCUDPSocket *udpSocket = (__bridge GVCUDPSocket *) info;
//    assert([obj isKindOfClass:[UDPEcho class]]);
    
#pragma unused(s)
//    assert(s == udpSocket->cfSocket);
#pragma unused(type)
//    assert(type == kCFSocketReadCallBack);
#pragma unused(address)
//    assert(address == nil);
#pragma unused(data)
//    assert(data == nil);
    
    [udpSocket readData];
}

@implementation GVCUDPSocket

@synthesize port;

- (id)initWithPort:(NSUInteger)p
{
    self = [super init];
    if (self != nil)
	{
		GVC_ASSERT(p > 0, @"Server port must be greater than 0");
		GVC_ASSERT(p < 65536, @"Server port must be less than 65536");

		port = p;
    }
    return self;
}

- (void)dealloc
{
    [self stop];
}

- (void)stop
{
	port = 0;
    if (cfSocket != NULL)
	{
        CFSocketInvalidate(cfSocket);
        CFRelease(cfSocket);
        cfSocket = NULL;
    }
}

	// Sets up the CFSocket in either client or server mode.  In client mode, 
	// address contains the address that the socket should be connected to. 
	// The address contains zero port number, so the port parameter is used instead. 
	// In server mode, address is nil and the socket is bound to the wildcard 
	// address on the specified port.
- (BOOL)setupSocketConnectedToAddress:(NSData *)address port:(NSUInteger)p error:(NSError **)errorPtr
{
	sa_family_t             socketFamily;
	int                     err;
	int                     junk;
	int                     sock;
	const CFSocketContext   context = { 0, (__bridge void *) self, NULL, NULL, NULL };
	CFRunLoopSourceRef      rls;
	
//	assert( (address == nil) == self.isServer );
//	assert( (address == nil) || ([address length] <= sizeof(struct sockaddr_storage)) );
//	assert(port < 65536);
//	
//	assert(cfSocket == NULL);
	
        // Create the UDP socket itself.  First try IPv6 and, if that's not available, revert to IPv6. 
        //
        // IMPORTANT: Even though we're using IPv6 by default, we can still work with IPv4 due to the 
        // miracle of IPv4-mapped addresses.
	
	err = 0;
	sock = socket(AF_INET6, SOCK_DGRAM, 0);
	if (sock >= 0)
	{
		socketFamily = AF_INET6;
	}
	else 
	{
		sock = socket(AF_INET, SOCK_DGRAM, 0);
		if (sock >= 0) 
		{
			socketFamily = AF_INET;
		}
		else
		{
			err = errno;
			socketFamily = 0;       // quietens a warning from the compiler
			assert(err != 0);       // Obvious, but it quietens a warning from the static analyser.
		}
	}
	
        // Bind or connect the socket, depending on whether we're in server or client mode.
	
	if (err == 0) 
	{
		struct sockaddr_storage addr;
		struct sockaddr_in *    addr4;
		struct sockaddr_in6 *   addr6;
		
		addr4 = (struct sockaddr_in * ) &addr;
		addr6 = (struct sockaddr_in6 *) &addr;
		
		memset(&addr, 0, sizeof(addr));
		if (address == nil) 
		{
                // Server mode.  Set up the address based on the socket family of the socket 
                // that we created, with the wildcard address and the caller-supplied port number.
			addr.ss_family = socketFamily;
			if (socketFamily == AF_INET) 
			{
				addr4->sin_len         = sizeof(*addr4);
				addr4->sin_port        = htons(p);
				addr4->sin_addr.s_addr = INADDR_ANY;
			} 
			else
			{
				assert(socketFamily == AF_INET6);
				addr6->sin6_len         = sizeof(*addr6);
				addr6->sin6_port        = htons(p);
				addr6->sin6_addr        = in6addr_any;
			}
		} 
		else
		{
                // Client mode.  Set up the address on the caller-supplied address and port 
                // number.  Also, if the address is IPv4 and we created an IPv6 socket, 
                // convert the address to an IPv4-mapped address.
			if ([address length] > sizeof(addr))
			{
				assert(NO);         // very weird
				[address getBytes:&addr length:sizeof(addr)];
			}
			else
			{
				[address getBytes:&addr length:[address length]];
			}
			
			if (addr.ss_family == AF_INET) 
			{
				if (socketFamily == AF_INET6) 
				{
					struct	in_addr ipv4Addr;
					
                        // Convert IPv4 address to IPv4-mapped-into-IPv6 address.
					
					ipv4Addr = addr4->sin_addr;
					
					addr6->sin6_len         = sizeof(*addr6);
					addr6->sin6_family      = AF_INET6;
					addr6->sin6_port        = htons(p);
					addr6->sin6_addr.__u6_addr.__u6_addr32[0] = 0;
					addr6->sin6_addr.__u6_addr.__u6_addr32[1] = 0;
					addr6->sin6_addr.__u6_addr.__u6_addr16[4] = 0;
					addr6->sin6_addr.__u6_addr.__u6_addr16[5] = 0xffff;
					addr6->sin6_addr.__u6_addr.__u6_addr32[3] = ipv4Addr.s_addr;
				}
				else
				{
					addr4->sin_port = htons(p);
				}
			} 
			else
			{
				assert(addr.ss_family == AF_INET6);
				addr6->sin6_port        = htons(p);
			}
			
			if ( (addr.ss_family == AF_INET) && (socketFamily == AF_INET6) ) 
			{
				addr6->sin6_len         = sizeof(*addr6);
				addr6->sin6_port        = htons(p);
				addr6->sin6_addr        = in6addr_any;
			}
		}
		if (address == nil) 
		{
			err = bind(sock, (const struct sockaddr *) &addr, addr.ss_len);
		}
		else
		{
			err = connect(sock, (const struct sockaddr *) &addr, addr.ss_len);
		}
		
		if (err < 0) 
		{
			err = errno;
		}
	}
	
        // From now on we want the socket in non-blocking mode to prevent any unexpected 
        // blocking of the main thread.  None of the above should block for any meaningful 
        // amount of time.
	
//	if (err == 0)
//	{
//		int flags;
//		
//		flags = fcntl(sock, F_GETFL);
//		err = fcntl(sock, F_SETFL, flags | O_NONBLOCK);
//		if (err < 0) {
//			err = errno;
//		}
//	}
	
        // Wrap the socket in a CFSocket that's scheduled on the runloop.
	
	if (err == 0)
	{
		cfSocket = CFSocketCreateWithNative(NULL, sock, kCFSocketReadCallBack, SocketReadCallback, &context);
		
            // The socket will now take care of cleaning up our file descriptor.
		
//		assert( CFSocketGetSocketFlags(cfSocket) & kCFSocketCloseOnInvalidate );
		sock = -1;
		
		rls = CFSocketCreateRunLoopSource(NULL, cfSocket, 0);
//		assert(rls != NULL);
		
		CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, kCFRunLoopDefaultMode);
		
		CFRelease(rls);
	}
	
        // Handle any errors.
	
	if (sock != -1) 
	{
		junk = close(sock);
		assert(junk == 0);
	}
	
//	assert( (err == 0) == (cfSocket != NULL) );
	if ( (cfSocket == NULL) && (errorPtr != NULL)) 
	{
		*errorPtr = [NSError errorWithDomain:NSPOSIXErrorDomain code:err userInfo:nil];
	}
	
	return (err == 0);
}


- (int)readData
    // Called by the CFSocket read callback to actually read and process data 
    // from the socket.
{
    int                     err;
    int                     sock;
    struct sockaddr_storage addr;
    socklen_t               addrLen;
    uint8_t                 buffer[65536];
    ssize_t                 bytesRead;
    
    sock = CFSocketGetNative( cfSocket );
//    assert(sock >= 0);
    
    addrLen = sizeof(addr);
    bytesRead = recvfrom(sock, buffer, sizeof(buffer), 0, (struct sockaddr *) &addr, &addrLen);
    if (bytesRead < 0) 
	{
        err = errno;
    }
	else if (bytesRead == 0) 
	{
        err = EPIPE;
    }
	else 
	{
        NSData *    dataObj;
        NSData *    addrObj;
		
        err = 0;
		
        dataObj = [NSData dataWithBytes:buffer length:(NSUInteger)bytesRead];
        assert(dataObj != nil);
        addrObj = [NSData dataWithBytes:&addr  length:addrLen  ];
        assert(addrObj != nil);
		
			// Tell the delegate about the data.
        
//        if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(echo:didReceiveData:fromAddress:)] ) 
//		{
//            [self.delegate echo:self didReceiveData:dataObj fromAddress:addrObj];
//        }
		
			// Echo the data back to the sender.
		
//        if (self.isServer) 
//		{
//            [self _sendData:dataObj toAddress:addrObj];
//        }
    }
    
		// If we got an error, tell the delegate.
    
//    if (err != 0)
//	{
//        if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(echo:didReceiveError:)] ) {
//            [self.delegate echo:self didReceiveError:[NSError errorWithDomain:NSPOSIXErrorDomain code:err userInfo:nil]];
//        }
//    }
	return err;
}


@end


@interface GVCUDPClientSocket ()
- (void)stopWithError:(NSError *)error;
- (void)stopWithStreamError:(CFStreamError)streamError;
- (void)stopHostResolution;
- (BOOL)hostResolutionDone;
- (void)hostResolutionStart;
@end



static void HostResolveCallback(CFHostRef theHost, CFHostInfoType typeInfo, const CFStreamError *error, void *info)
    // This C routine is called by CFHost when the host resolution is complete. 
    // It just redirects the call to the appropriate Objective-C method.
{
    GVCUDPClientSocket *client = (__bridge GVCUDPClientSocket *) info;
    
//#pragma unused(theHost)
//    GVC_ASSERT( theHost == client->cfHost, @"Mismatched host");
	
#pragma unused(typeInfo)
    GVC_ASSERT(typeInfo == kCFHostAddresses, @"Mismatched host typeinfo");
    
    if ((error != NULL) && (error->domain != 0) ) 
	{
        [client stopWithStreamError:*error];
    }
	else 
	{
        [client hostResolutionDone];
    }
}

@implementation GVCUDPClientSocket

@synthesize hostName;
@synthesize hostAddress;

- (id)initWithHostname:(NSString *)host onPort:(NSUInteger)p
{
    self = [super initWithPort:p];
	if ( self != nil )
	{
		GVC_ASSERT(host != nil, @"Server address is required");
		hostName = [host copy];
		[self hostResolutionStart];
	}
	return self;
}

- (void)hostResolutionStart
{
	BOOL success = NO;
	
	CFHostClientContext context = {0, (__bridge void *) self, NULL, NULL, NULL};
	CFStreamError streamError;
	
	cfHost = CFHostCreateWithName(NULL, (__bridge CFStringRef)hostName);
	GVC_ASSERT(cfHost != NULL, @"Failed to allocate CFHost");
	
	CFHostSetClient( cfHost, HostResolveCallback, &context);
	
	CFHostScheduleWithRunLoop( cfHost, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	success = (BOOL)CFHostStartInfoResolution( cfHost, kCFHostAddresses, &streamError);
	if (success == NO) 
	{
		[self stopWithStreamError:streamError];
	}
}

- (BOOL)hostResolutionDone
{
    NSError *           error = nil;
    Boolean             resolved;
    NSArray *           resolvedAddresses = nil;
    
//    assert(self.port != 0);
//    assert(cfHost != NULL);
//    assert(cfSocket == NULL);
//    assert(self.hostAddress == nil);
    
		// Walk through the resolved addresses looking for one that we can work with.
    resolvedAddresses = (__bridge NSArray *) CFHostGetAddressing( cfHost, &resolved);
    if ((resolved == YES) && (resolvedAddresses != nil) ) 
	{
        for (NSData * address in resolvedAddresses) 
		{
            const struct sockaddr * addrPtr;
//            NSUInteger              addrLen;
            
            addrPtr = (const struct sockaddr *) [address bytes];
//            addrLen = [address length];
//            assert(addrLen >= sizeof(struct sockaddr));
			
				// Try to create a connected CFSocket for this address.  If that fails, 
				// we move along to the next address.  If it succeeds, we're done.
            
            if ((addrPtr->sa_family == AF_INET) || (addrPtr->sa_family == AF_INET6))
			{
                BOOL success = [self setupSocketConnectedToAddress:address port:[self port] error:&error];
                if (success == YES) 
				{
                    CFDataRef   hostData = CFSocketCopyPeerAddress( cfSocket);
//                    assert(hostAddress != NULL);
                    
                    hostAddress = [(__bridge NSData *) hostData copy];
                    
                    CFRelease(hostData);
					break;
                }
            }
        }
    }
    
		// If we didn't get an address and didn't get an error, synthesise a host not found error.
    
    if ( (self.hostAddress == nil) && (error == nil) ) {
        error = [NSError errorWithDomain:(NSString *)kCFErrorDomainCFNetwork code:kCFHostErrorHostNotFound userInfo:nil];
    }
	
    if (error == nil) 
	{
			// We're done resolving, so shut that down.
        [self stopHostResolution];
		
			// Tell the delegate that we're up.
//        if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(echo:didStartWithAddress:)] ) {
//            [self.delegate echo:self didStartWithAddress:self.hostAddress];
//        }
    } 
	else
	{
        [self stopWithError:error];
    }
	return (BOOL)resolved;
}

- (void)stop
{
    hostAddress = nil;
    [self stopHostResolution];
	[super stop];
}

- (void)stopHostResolution
    // Called to stop the CFHost part of the object, if it's still running.
{
    if (cfHost != NULL) 
	{
        CFHostSetClient(cfHost, NULL, NULL);
        CFHostCancelInfoResolution(cfHost, kCFHostAddresses);
        CFHostUnscheduleFromRunLoop(cfHost, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        CFRelease(cfHost);
        cfHost = NULL;
    }
}

- (void)stopWithError:(NSError *)error
    // Stops the object, reporting the supplied error to the delegate.
{
//    assert(error != nil);
    [self stop];
//    if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(echo:didStopWithError:)] ) 
//	{
//        [[self retain] autorelease];
//        [self.delegate echo:self didStopWithError:error];
//    }
}

- (void)stopWithStreamError:(CFStreamError)streamError
{
    NSDictionary *  userInfo;
    NSError *       error;
	
    if (streamError.domain == kCFStreamErrorDomainNetDB) 
	{
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:streamError.error], kCFGetAddrInfoFailureKey, nil];
    }
	else 
	{
        userInfo = nil;
    }
    
	error = [NSError errorWithDomain:(NSString *)kCFErrorDomainCFNetwork code:kCFHostErrorUnknown userInfo:userInfo];
//    assert(error != nil);
    
    [self stopWithError:error];
}

- (BOOL)sendData:(NSData *)data
{
    int err = 0;
	if ( CFSocketIsValid(cfSocket) == NO )
	{
		[self stop];
		[self hostResolutionStart];
	}
	else
	{
		int                     sock;
		ssize_t                 bytesWritten;
			//    const struct sockaddr * addrPtr;
			//    socklen_t               addrLen;
		
			//    assert(data != nil);
			//    assert( (addr != nil) == self.isServer );
			//    assert( (addr == nil) || ([addr length] <= sizeof(struct sockaddr_storage)) );
		
		sock = CFSocketGetNative( cfSocket );
			//    assert(sock >= 0);
	    
		bytesWritten = sendto(sock, [data bytes], [data length], 0, NULL, 0);
		if (bytesWritten < 0) 
		{
			err = errno;
		}
		else  if (bytesWritten == 0) 
		{
			err = EPIPE;                    
		}
		else 
		{
				// We ignore any short writes, which shouldn't happen for UDP anyway.
			assert( (NSUInteger) bytesWritten == [data length] );
			err = 0;
		}
		
		if (err == 0) 
		{
				//        if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(echo:didSendData:toAddress:)] ) {
				//            [self.delegate echo:self didSendData:data toAddress:addr];
				//        }
		}
		else
		{
				//        if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(echo:didFailToSendData:toAddress:error:)] ) {
				//            [self.delegate echo:self didFailToSendData:data toAddress:addr error:[NSError errorWithDomain:NSPOSIXErrorDomain code:err userInfo:nil]];
				//        }
		}
	}
	
	return (err == 0);
}



@end

