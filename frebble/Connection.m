//
//  Connection.m
//  frebble
//
//  Created by S. Mooij on 05/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import "Connection.h"

@implementation Connection

static Connection *sharedInstance  = nil;

+ (Connection *)sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        delegates_ = [[NSMutableArray alloc] init];
        open_ = NO;
        _username_ = nil;
        _partner_ = nil;
    }
    return self;
}

- (void) addDelegate:(id<ConnectionDelegate>) delegate
{
    @synchronized(self)
    {
        if (![delegates_ containsObject:delegate])
        {
            [delegates_ addObject:delegate];
        }
    }
}

- (void) removeDelegate:(id<ConnectionDelegate>) delegate
{
    @synchronized(self)
    {
        [delegates_ removeObject:delegate];
    }
}

- (void) didMessageServerLoginSucces:(NSString*)username
{
    NSLog(@"Connection didMessageServerLoginSucces {");
    @synchronized(self)
    {
        _username_ = username;
        NSArray* delegatesCopy = [delegates_ copy];
        for (id<ConnectionDelegate> delegate in delegatesCopy)
        {
            [delegate didMessageServerLoginSucces:username];
        }
    }
    NSLog(@"Connection didMessageServerLoginSucces }");
}

- (void) didMessageServerSessionInvite:(NSString *)partner
{
    NSLog(@"Connection didMessageServerSessionInvite {");
    _partner_ = partner;
    @synchronized(self)
    {
        NSArray* delegatesCopy = [delegates_ copy];
        for (id<ConnectionDelegate> delegate in delegatesCopy)
        {
            [delegate didMessageServerSessionInvite:partner];
        }
    }
    NSLog(@"Connection didMessageServerSessionInvite }");
}

- (void) didMessageServerSessionInviting:(NSString *)partner
{
    _partner_ = partner;
    NSLog(@"Connection didMessageServerSessionInviting {");
    @synchronized(self)
    {
        NSArray* delegatesCopy = [delegates_ copy];
        for (id<ConnectionDelegate> delegate in delegatesCopy)
        {
            [delegate didMessageServerSessionInviting:partner];
        }
    }
    NSLog(@"Connection didMessageServerSessionInviting }");
}

- (void) didMessageServerSessionStart:(NSString *)username
{
    NSLog(@"Connection didMessageServerSessionStart {");
    @synchronized(self)
    {
        NSArray* delegatesCopy = [delegates_ copy];
        for (id<ConnectionDelegate> delegate in delegatesCopy)
        {
            [delegate didMessageServerSessionStart:username];
        }
    }
    NSLog(@"Connection didMessageServerSessionStart }");
}

- (void) didMessageServerSessionValue:(int)value
{
    NSLog(@"Connection didMessageServerSessionValue {");
    @synchronized(self)
    {
        NSArray* delegatesCopy = [delegates_ copy];
        for (id<ConnectionDelegate> delegate in delegatesCopy)
        {
            [delegate didMessageServerSessionValue:value];
        }
    }
    NSLog(@"Connection didMessageServerSessionValue }");
}

- (void) didMessageSimple:(int)message
{
    NSLog(@"Connection didMessageSimple: %d {", message);
    switch (message)
    {
        case MESSAGE_SERVER_SESSION_STOP:
        {
            _partner_ = nil;
            break;
        }
        case MESSAGE_SERVER_CREATE_USER_SUCCESS:
        case MESSAGE_SERVER_CREATE_USER_ERROR_USERNAME:
        case MESSAGE_SERVER_CREATE_USER_ERROR_EMAIL:
        {
            [self close];
        }
        default:
        {
            break;
        }
    }
    @synchronized(self)
    {
        NSArray* delegatesCopy = [delegates_ copy];
        for (id<ConnectionDelegate> delegate in delegatesCopy)
        {
            [delegate didMessageSimple:message];
        }
    }
    NSLog(@"Connection didMessageSimple: %d }", message);
}

- (void) didConnectionLost
{
    NSLog(@"Connection didConnectionLost {");
    @synchronized(self)
    {
        _username_ = nil;
        _partner_ = nil;
        for (id<ConnectionDelegate> delegate in delegates_)
        {
            [delegate didConnectionLost];
        }
    }
    NSLog(@"Connection didConnectionLost }");
}

- (void) open
{
    @synchronized(self)
    {
        if (!open_)
        {
            CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, HOST_NAME, HOST_PORT, &cfReadStreamRef_, &cfWriteStreamRef_);
            if (CFWriteStreamOpen(cfWriteStreamRef_))
            {
                in_ = (__bridge NSInputStream *)cfReadStreamRef_;
                [in_ setProperty:NSStreamNetworkServiceTypeVoIP forKey:NSStreamNetworkServiceType];
                out_ = (__bridge NSOutputStream *)cfWriteStreamRef_;
                [out_ setProperty:NSStreamNetworkServiceTypeVoIP forKey:NSStreamNetworkServiceType];
                [in_ setDelegate:self];
                [out_ setDelegate:self];
                [in_ scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                [out_ scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                [in_ open];
                [out_ open];
                [Message writeMagicVersion:out_];
                open_ = YES;
            }
        }
    }
}

- (void) create: (NSString *)username email: (NSString*) email passwordhash: (NSString *) passwordhash
{
    @synchronized(self)
    {
        [self close];
        [self open];
        [Message messageClientCreateUser:out_ username:username email:email passwordhash:passwordhash];
    }
}

- (void) close
{
    @synchronized(self)
    {
        if (open_)
        {
            open_ = NO;
            [in_ close];
            [out_ close];
            [in_ removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [out_ removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [in_ setDelegate:nil];
            [out_ setDelegate:nil];
            in_ = nil;
            out_ = nil;
        }
        [self didConnectionLost];
    }
}

- (void) login: (NSString *)usernameOrEmail passwordhash: (NSString *) passwordhash
{
    @synchronized(self)
    {
        [self close];
        [self open];
        [Message messageClientLogin:out_ usernameOrEmail:usernameOrEmail passwordhash:passwordhash];
    }
}

- (void) logout: (NSString *)usernameOrEmail
{
    @synchronized(self)
    {
        [self close];
    }
}

- (BOOL) isLoggedIn
{
    return _username_ != nil;
}

- (void) sessionInvite: (NSString *)usernameOrEmail
{
    @synchronized(self)
    {
        if ([self isLoggedIn])
        {
            [Message messageClientSessionInvite:out_ usernameOrEmail:usernameOrEmail];
        }
    }
}

- (void) sessionStart
{
    [Message messageClientSessionInvite:out_ usernameOrEmail:_partner_];
}

- (void) sessionValue: (int)value
{
    @synchronized(self)
    {
        if ([self isLoggedIn])
        {
            [Message messageClientSessionValue:out_ value:value];
        }
    }
}

- (void) sessionStop
{
    @synchronized(self)
    {
        if ([self isLoggedIn])
        {
            [Message messageSimple:out_ message:MESSAGE_CLIENT_SESSION_STOP];
            [Message messageSimple:out_ message:MESSAGE_SERVER_SESSION_STOP];
        }
    }
}

- (void) sessionKill
{
    @synchronized(self)
    {
        if ([self isLoggedIn])
        {
            [self sessionStop];
            [Message messageSimple:out_ message:-100];
        }
    }
}

- (void) stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode)
    {
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"NSStreamEventHasSpaceAvailable");
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"NSStreamEventHasBytesAvailable");
            if (aStream == in_)
            {
                // read MESSAGE length
                [Message readInt:in_];
                int message = [Message readInt:in_];
                NSLog(@"message: %d", message);
                switch (message)
                {
                    case MESSAGE_SERVER_LOGIN_SUCCESS:
                        [self didMessageServerLoginSucces:[Message readString:in_]];
                        break;
                    case MESSAGE_SERVER_SESSION_INVITING:
                        [self didMessageServerSessionInviting:[Message readString:in_]];
                        break;
                    case MESSAGE_SERVER_SESSION_INVITE:
                        [self didMessageServerSessionInvite:[Message readString:in_]];
                        break;
                    case MESSAGE_SERVER_SESSION_START:
                        [self didMessageServerSessionStart:[Message readString:in_]];
                        break;
                    case MESSAGE_SERVER_SESSION_VALUE:
                        [self didMessageServerSessionValue:[Message readInt:in_]];
                        break;
                    default:
                        [self didMessageSimple:message];
                        break;
                }
            }
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"NSStreamEventEndEncountered");
            [self close];
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"NSStreamEventErrorOccurred");
            [self close];
            break;
        case NSStreamEventNone:
            NSLog(@"NSStreamEventNone");
            break;
        case NSStreamEventOpenCompleted:
            NSLog(@"NSStreamEventOpenCompleted");
            break;
    }
}

@end
