//
//  Frebble.h
//  frebble
//
//  Created by S. Mooij on 16/02/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FrebbleDelegate.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "defaults.h"

@interface Frebble : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate, FrebbleDelegate>
{
    CBCentralManager* cbCentralManager;
    NSMutableArray* delegates;
    BOOL shouldBeScanning;
    BOOL shouldBeConnected;
    NSString* selected;
    CBPeripheral* connected;
    CBCharacteristic* characteristic_tx;
};

+ (Frebble *)sharedInstance;

- (void) addDelegate:(id<FrebbleDelegate>) delegate;

- (void) removeDelegate:(id<FrebbleDelegate>) delegate;

- (void) startScanning;

- (void) stopScanning;

- (void) select:(NSString*) new;

- (BOOL) connect;

- (void) disConnect;

- (BOOL) shouldBeConnected;

- (BOOL) isConnected;

- (void) setPressure: (int) value;

- (NSString *) selected;

@end