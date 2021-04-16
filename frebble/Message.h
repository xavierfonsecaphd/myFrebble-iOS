//
//  Message.h
//  frebble
//
//  Created by T Test on 11/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import <Foundation/Foundation.h>

static int const MESSAGE_CLIENT_CREATE_USER = 0;
static int const MESSAGE_CLIENT_LOGIN = 1;
static int const MESSAGE_CLIENT_SESSION_INVITE = 2;
static int const MESSAGE_CLIENT_SESSION_VALUE = 3;
static int const MESSAGE_CLIENT_SESSION_STOP = 4;
static int const MESSAGE_SERVER_CREATE_USER_SUCCESS = 0;
static int const MESSAGE_SERVER_CREATE_USER_ERROR_USERNAME = 1;
static int const MESSAGE_SERVER_CREATE_USER_ERROR_EMAIL = 2;
static int const MESSAGE_SERVER_LOGIN_SUCCESS = 3;
static int const MESSAGE_SERVER_LOGIN_ERROR = 4;
static int const MESSAGE_SERVER_SESSION_INVITE = 5;
static int const MESSAGE_SERVER_SESSION_INVITING = 6;
static int const MESSAGE_SERVER_SESSION_START = 7;
static int const MESSAGE_SERVER_SESSION_VALUE = 8;
static int const MESSAGE_SERVER_SESSION_STOP = 9;
static int const MESSAGE_SERVER_SESSION_PARTNER_OFFLINE = 10;
static int const MESSAGE_SERVER_SESSION_PARTNER_NOTEXIST = 11;
static int const MESSAGE_SERVER_SESSION_PARTNER_BUSY = 12;

@interface Message : NSObject

+ (int) readInt:(NSInputStream *)in;

+ (NSString*) readString:(NSInputStream*)in;

+ (void) writeMagicVersion:(NSOutputStream*)out;

+ (void) messageClientCreateUser:(NSOutputStream*)out username:(NSString*)username email:(NSString*)email passwordhash:(NSString*)passwordhash;

+ (void) messageClientLogin:(NSOutputStream *)out usernameOrEmail:(NSString*)usernameOrEmail passwordhash:(NSString*)passwordhash;

+ (void) messageClientSessionInvite:(NSOutputStream*)out usernameOrEmail:(NSString*)usernameOrEmail;

+ (void) messageSimple:(NSOutputStream*) out message:(int) message;

+ (void) messageClientSessionValue:(NSOutputStream*)out value:(int)value;

@end
