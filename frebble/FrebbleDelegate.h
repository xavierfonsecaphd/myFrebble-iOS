//
//  FrebbleObserver.h
//  frebble
//
//  Created by S. Mooij on 26/02/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

@protocol FrebbleDelegate <NSObject>

- (void) didDiscover:(NSString*) identifier;

- (void) didConnect;

- (void) didDisconnect;

- (void) didUpdatePressure:(int) value;

@end