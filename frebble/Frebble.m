//
//  Frebble.m
//  frebble
//
//  Created by S. Mooij on 16/02/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import "Frebble.h"

@implementation Frebble

static Frebble *sharedInstance = nil;

+ (Frebble *)sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
        NSLog(@"sharedInstance singleton created");
    }
    return sharedInstance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        cbCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options: nil];
        delegates = [[NSMutableArray alloc] init];
        shouldBeScanning = NO;
        shouldBeConnected = NO;
        selected = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PREFERENCES_KEY_SELECTED_FREBBLE];
        connected = nil;
        characteristic_tx = nil;
    }
    return self;
}

- (void) addDelegate:(id<FrebbleDelegate>) delegate
{
    @synchronized(self)
    {
        [delegates addObject:delegate];
    }
}

- (void) removeDelegate:(id<FrebbleDelegate>) delegate
{
    @synchronized(self)
    {
        [delegates removeObject:delegate];
    }
}

- (void) didDiscover:(NSString*) identifier
{
    NSLog(@"Frebble didDiscover {");
    @synchronized(self)
    {
        for (id<FrebbleDelegate> delegate in delegates)
        {
            [delegate didDiscover: identifier];
        }
    }
    NSLog(@"Frebble didDiscover }");
}

- (void) didConnect
{
    NSLog(@"Frebble didConnect {");
    @synchronized(self)
    {
        for (id<FrebbleDelegate> delegate in delegates)
        {
            [delegate didConnect];
        }
    }
    NSLog(@"Frebble didConnect }");
}

- (void) didDisconnect
{
    NSLog(@"Frebble didDisconnect {");
    @synchronized(self)
    {
        for (id<FrebbleDelegate> delegate in delegates)
        {
            [delegate didDisconnect];
        }
    }
    NSLog(@"Frebble didDisconnect }");
}

- (void) didUpdatePressure:(int) value
{
    NSLog(@"Frebble didUpdatePressure {");
    @synchronized(self)
    {
        for (id<FrebbleDelegate> delegate in delegates)
        {
            [delegate didUpdatePressure:value];
        }
    }
    NSLog(@"Frebble didUpdatePressure }");
}

- (void) startScanning
{
    NSLog(@"Frebble startScanning {");
    @synchronized(self)
    {
        if (!shouldBeConnected)
        {
            shouldBeScanning = YES;
            [cbCentralManager scanForPeripheralsWithServices:nil options:nil];
        }
    }
    NSLog(@"Frebble startScanning }");
}

- (void) stopScanning
{
    NSLog(@"Frebble stopScanning {");
    @synchronized (self)
    {
        if (!shouldBeConnected)
        {
            shouldBeScanning = NO;
            [cbCentralManager stopScan];
        }
    }
    NSLog(@"Frebble stopScanning }");
}

- (void) select:(NSString*) new
{
    NSLog(@"Frebble select {");
    @synchronized (self)
    {
        if (!shouldBeConnected)
        {
            selected = new;
            NSUserDefaults* nsUserDefaults = [NSUserDefaults standardUserDefaults];
            [nsUserDefaults setObject:new forKey:USER_PREFERENCES_KEY_SELECTED_FREBBLE];
            [nsUserDefaults synchronize];
        }
    }
    NSLog(@"Frebble select }");
}

- (BOOL) connect
{
    NSLog(@"Frebble connect {");
    BOOL result;
    @synchronized (self)
    {
        if (selected == nil)
        {
            result = NO;
        }
        else
        {
            if (!shouldBeConnected)
            {
                shouldBeScanning = YES;
                shouldBeConnected = YES;
                [cbCentralManager scanForPeripheralsWithServices:nil options:nil];
            }
            result = YES;
        }
    }
    NSLog(@"Frebble connect }");
    return result;
}

- (void) disConnect
{
    NSLog(@"Frebble disConnect {");
    @synchronized (self)
    {
        if (shouldBeConnected)
        {
            if (connected == nil)
            {
                shouldBeScanning = NO;
                shouldBeConnected = NO;
                [cbCentralManager stopScan];
                [self didDisconnect];
            }
            else
            {
                [cbCentralManager cancelPeripheralConnection: connected];
            }
        }
    }
    NSLog(@"Frebble disConnect }");
}

- (BOOL) shouldBeConnected
{
    return shouldBeConnected;
}

- (BOOL) isConnected
{
    return connected != nil;
}

- (NSString *) selected
{
    return selected;
}

- (void) setPressure: (int) value
{
    NSLog(@"Frebble setPressure: %d {", value);
    @synchronized (self)
    {
        if (characteristic_tx != nil)
        {
            NSString* string = [NSString stringWithFormat:@"%d", value];
            NSData* data = [string dataUsingEncoding:NSASCIIStringEncoding];
            [connected writeValue:data forCharacteristic:characteristic_tx type:CBCharacteristicWriteWithoutResponse];
        }
    }
    NSLog(@"Frebble setPressure: %d }", value);
}


/*
    This is the method updating the bluetooth status, and reacting according to status change. 
    (example, enabling bluetooth, and initializing a scan right after that)
 */
- (void) centralManagerDidUpdateState:(CBCentralManager *) central
{
    NSLog(@"Frebble centralManagerDidUpdateState {");
    @synchronized (self)
    {
        switch ([cbCentralManager state])
        {
            case CBCentralManagerStatePoweredOff:
            {
                NSLog(@"CBCentralManagerStatePoweredOff");
                break;
            }
            case CBCentralManagerStateUnauthorized:
            {
                NSLog(@"CBCentralManagerStateUnauthorized");
                break;
            }
            case CBCentralManagerStatePoweredOn:
            {
                NSLog(@"CBCentralManagerStatePoweredOn");
                if (shouldBeScanning)
                {
                    [self startScanning];
                }
                break;
            }
            case CBCentralManagerStateResetting:
            {
                NSLog(@"CBCentralManagerStateResetting");
                break;
            }
            case CBCentralManagerStateUnknown:
            {
                NSLog(@"CBCentralManagerStateUnknown");
                break;
            }
            case CBCentralManagerStateUnsupported:
            {
                NSLog(@"CBCentralManagerStateUnsupported");
                break;
            }
        }
    }
    NSLog(@"Frebble centralManagerDidUpdateState }");
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Frebble centralManager didDiscoverPeripheral {");
    @synchronized (self)
    {
        if ([[peripheral name] isEqualToString: @"Frebble"])
        {
            if (shouldBeConnected && [selected isEqualToString: [[peripheral identifier] UUIDString]])
            {
                shouldBeScanning = NO;
                [cbCentralManager stopScan];
                connected = peripheral;
                [cbCentralManager connectPeripheral: connected options: nil];
            }
            else
            {
                [self didDiscover: [[peripheral identifier] UUIDString]];
            }
        }
    }
    NSLog(@"Frebble centralManager didDiscoverPeripheral }");
}

- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Frebble centralManager didFailToConnectPeripheral {");
    NSLog(@"Error: %@", error);
    NSLog(@"Frebble centralManager didFailToConnectPeripheral }");
}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Frebble centralManager didConnectPeripheral {");
    @synchronized (self)
    {
        [self didConnect];
        peripheral.delegate = self;
        [peripheral discoverServices:@[[CBUUID UUIDWithString:BLUETOOTH_KEY_SERVICE]]];
    }
    NSLog(@"Frebble centralManager didConnectPeripheral }");
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Bluetooth centralManager didDisconnectPeripheral {");
    @synchronized (self)
    {
        shouldBeConnected = NO;
        connected = nil;
        characteristic_tx = nil;
        [self didDisconnect];
    }
    NSLog(@"Bluetooth centralManager didDisconnectPeripheral }");
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"peripheral didDiscoverServices {");
    for (CBService *service in [peripheral services])
    {
        NSLog(@"Discovered service %@", service);
        [peripheral discoverCharacteristics:nil forService:service];
    
    }
    NSLog(@"peripheral didDiscoverServices {");
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"peripheral didDiscoverCharacteristicsForService {");
    for (CBCharacteristic *characteristic in [service characteristics])
    {
        NSLog(@"Characteristic: %@", characteristic);
        if ([[[characteristic UUID] UUIDString] isEqualToString:BLUETOOTH_KEY_TX])
        {
            characteristic_tx = characteristic;
        }
        if ([[[characteristic UUID] UUIDString] isEqualToString:BLUETOOTH_KEY_RX])
        {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    NSLog(@"peripheral didDiscoverCharacteristicsForService }");
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic value] != nil)
    {
        NSData *value = [characteristic value];
        int number = [[[NSString alloc] initWithData:value encoding:NSASCIIStringEncoding] intValue];
        [self didUpdatePressure:number];
    }
}

@end