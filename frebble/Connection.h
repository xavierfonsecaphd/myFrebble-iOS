//
//  Connection.h
//  frebble
//
//  Created by S. Mooij on 05/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defaults.h"
#import "ConnectionDelegate.h"
#import "Message.h"

@interface Connection : NSObject <NSStreamDelegate, ConnectionDelegate>
{
    NSMutableArray* delegates_;
    BOOL open_;
    CFReadStreamRef cfReadStreamRef_;
    CFWriteStreamRef cfWriteStreamRef_;
    NSInputStream *in_;
    NSOutputStream *out_;
}

@property (strong, nonatomic) NSString* username_;

@property (strong, nonatomic) NSString* partner_;

+ (Connection *) sharedInstance;

@property (strong, nonatomic) NSString *activeUsername;

- (void) addDelegate:(id<ConnectionDelegate>) delegate;

- (void) removeDelegate:(id<ConnectionDelegate>) delegate;

- (void) create: (NSString *)username email: (NSString*) email passwordhash: (NSString *) passwordhash;

- (void) login: (NSString *)usernameOrEmail passwordhash: (NSString *) passwordhash;

- (void) logout: (NSString *)usernameOrEmail;

- (BOOL) isLoggedIn;

- (void) sessionInvite: (NSString *)usernameOrEmail;

- (void) sessionStart;

- (void) sessionValue: (int)value;

- (void) sessionStop;

// for logout buttons
- (void) sessionKill;

@end
