//
//  defaults.h
//  frebble
//
//  Created by T Test on 02/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#ifndef frebble_defaults_h
#define frebble_defaults_h

static NSString* const GOOGLE_CLIENT_ID = @"992742234833-380lkckuit929rem75buqotb0mha6i7r.apps.googleusercontent.com";
static NSString* const USER_PREFERENCES_KEY_SELECTED_FREBBLE = @"frebble-selected";
static NSString* const BLUETOOTH_KEY_SERVICE = @"6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
static NSString* const BLUETOOTH_KEY_RX = @"6E400003-B5A3-F393-E0A9-E50E24DCCA9E";
static NSString* const BLUETOOTH_KEY_TX = @"6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
static CFStringRef const HOST_NAME = (CFStringRef)@"ios.hollandhaptics.com";
static int const HOST_PORT = 13145;
static int const MAGICNUMBER  = 0x4A3B2C1D;
static int const VERSION = 0;
static int const COMMAND_SESSION_NEW = 10000;
static int const COMMAND_SESSION_CONNECT = 10001;
static int const COMMAND_SESSION_START = 10002;
static int const COMMAND_SESSION_STOP = 10003;

#endif