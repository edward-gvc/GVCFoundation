//
//  GVCUDPSocket.h
//
//  Created by David Aspinall on 11-05-20.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sys/socket.h>

#if TARGET_OS_EMBEDDED || TARGET_IPHONE_SIMULATOR
#import <CFNetwork/CFNetwork.h>
#else
#import <CoreServices/CoreServices.h>
#endif

#define TEST_BIT(__FLAG__,__BIT__)	((__FLAG__ & (1 << __BIT__)) == __BIT__)
#define SET_BIT(__FLAG__,__BIT__)	__FLAG__ |= (1 << __BIT__);


@interface GVCUDPSocket : NSObject 
{
    NSUInteger port;
	CFSocketRef  cfSocket;
}

@property (nonatomic, assign, readonly ) NSUInteger port;

- (id)initWithPort:(NSUInteger)p;
- (void)stop;

@end


@interface GVCUDPClientSocket : GVCUDPSocket
{
    CFHostRef cfHost;
	NSString *hostName;
	NSData *hostAddress;
}

@property (nonatomic, copy, readonly ) NSString *hostName;
@property (nonatomic, copy, readonly ) NSData *hostAddress;

- (id)initWithHostname:(NSString *)hostname onPort:(NSUInteger)port;

- (BOOL)sendData:(NSData *)data;

@end


@interface GVCUDPServerSocket : GVCUDPSocket
{
}

@end
