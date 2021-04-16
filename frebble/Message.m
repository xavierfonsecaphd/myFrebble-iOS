//
//  Message.m
//  frebble
//
//  Created by T Test on 11/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import "Message.h"
#import "defaults.h"

@implementation Message

+ (int) readInt:(NSInputStream *)in
{
    uint8_t buffer[4];
    [in read:buffer maxLength:4];
    int result = 0;
    result += buffer[0] << (3 * 8);
    result += buffer[1] << (2 * 8);
    result += buffer[2] << (1 * 8);
    result += buffer[3] << (0 * 8);
    return result;
}

+ (NSString*) readString:(NSInputStream*)in
{
    int length = [Message readInt:in];
    uint8_t buffer[length];
    [in read:buffer maxLength:length];
    NSMutableData* data = [[NSMutableData alloc] init];
    [data appendBytes:buffer length:length];
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+ (void) writeInt:(NSOutputStream*)out value:(int) value
{
    uint8_t buffer[4];
    buffer[0] = (value >> (3 * 8)) & 0x000000ff;
    buffer[1] = (value >> (2 * 8)) & 0x000000ff;
    buffer[2] = (value >> (1 * 8)) & 0x000000ff;
    buffer[3] = (value >> (0 * 8)) & 0x000000ff;
    [out write: buffer maxLength:4];
}

+ (void) writeString:(NSOutputStream*)out string:(NSString*)string
{
    [Message writeInt:out value:[string length]];
    if ([string length] > 0)
    {
        const uint8_t* bytes = (uint8_t*)[string cStringUsingEncoding:NSASCIIStringEncoding];
        NSLog(@"write: %d", [out write:bytes maxLength:[string length]]);
    }
}

+ (void) writeMagicVersion:(NSOutputStream*)out
{
    [Message writeInt:out value:MAGICNUMBER];
    [Message writeInt:out value:VERSION];
}

+ (void) messageClientCreateUser:(NSOutputStream*)out username:(NSString*)username email:(NSString*)email passwordhash:(NSString*)passwordhash
{
    [Message writeInt:out value:4 + 4 + 4 + [username length] + 4 + [email length] + 4 + [passwordhash length]];
    [Message writeInt:out value:MESSAGE_CLIENT_CREATE_USER];
    [Message writeString:out string:username];
    [Message writeString:out string:email];
    [Message writeString:out string:passwordhash];
}

+ (void) messageClientLogin:(NSOutputStream *)out usernameOrEmail:(NSString*)usernameOrEmail passwordhash:(NSString*)passwordhash
{
    [Message writeInt:out value:4 + 4 + 4 + [usernameOrEmail length] + 4 + [passwordhash length]];
    [Message writeInt:out value:MESSAGE_CLIENT_LOGIN];
    [Message writeString:out string:usernameOrEmail];
    [Message writeString:out string:passwordhash];
}

+ (void) messageClientSessionInvite:(NSOutputStream*)out usernameOrEmail:(NSString*)usernameOrEmail
{
    [Message writeInt:out value:4 + 4 + 4 + [usernameOrEmail length]];
    [Message writeInt:out value:MESSAGE_CLIENT_SESSION_INVITE];
    [Message writeString:out string:usernameOrEmail];
}

+ (void) messageSimple:(NSOutputStream*)out message: (int) message;
{
    [Message writeInt:out value:4 + 4];
    [Message writeInt:out value:message];
}

+ (void) messageClientSessionValue:(NSOutputStream*)out value:(int)value
{
    [Message writeInt:out value:4 + 4 + 4];
    [Message writeInt:out value:MESSAGE_CLIENT_SESSION_VALUE];
    [Message writeInt:out value:value];
}

@end
