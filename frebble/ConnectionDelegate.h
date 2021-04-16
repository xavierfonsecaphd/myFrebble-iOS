//
//  ConnectionDelegate.h
//  frebble
//
//  Created by S. Mooij on 05/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

@protocol ConnectionDelegate <NSObject>

- (void) didMessageServerLoginSucces:(NSString*)username;

- (void) didMessageServerSessionInvite:(NSString *)partner;

- (void) didMessageServerSessionInviting:(NSString *)partner;

- (void) didMessageServerSessionStart:(NSString *)partner;

- (void) didMessageServerSessionValue:(int)value;

- (void) didMessageSimple:(int)message;

- (void) didConnectionLost;

@end