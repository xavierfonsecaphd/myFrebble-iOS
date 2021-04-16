//
//  SessionViewController.m
//  frebble
//
//  Created by T Test on 15/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import "SessionViewController.h"
#import "UICKeyChainStore/UICKeyChainStore.h"

@implementation SessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FrebbleConnectViewController* frebbleConnectViewController = [[FrebbleConnectViewController alloc] init];
    frebbleConnectViewController.view.frame = _viewFrebbleConnect.bounds;
    [self.viewFrebbleConnect addSubview:frebbleConnectViewController.view];
    [self addChildViewController:frebbleConnectViewController];
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
    self.usernameLabel.text = [Connection sharedInstance].activeUsername;
    /*
    if (![_activeUsername isEqualToString:@""])
    {
        self.usernameLabel.text = _activeUsername;
    }*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[Frebble sharedInstance] addDelegate:self];
    _textFieldPartner.text = [[Connection sharedInstance] partner_];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
    self.usernameLabel.text = [Connection sharedInstance].activeUsername;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[Frebble sharedInstance] removeDelegate:self];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void) didDiscover:(NSString*) identifier
{
}

- (void) didConnect
{
}

- (void) didDisconnect
{
    
}

- (void) didUpdatePressure:(int) value
{
    [[Connection sharedInstance] sessionValue:value];
}

- (IBAction)actionSessionStop:(id)sender
{
    NSLog(@"action session stop");
    [[Connection sharedInstance] sessionStop];
        [self performSegueWithIdentifier:@"segueStopSession" sender:self];

    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    

}

- (IBAction)actionLogout:(id)sender
{
    NSLog(@"action logout");
    [[Connection sharedInstance] sessionKill];
    [self performSegueWithIdentifier:@"segue2Logout" sender:self];
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
    [UICKeyChainStore removeAllItems];
    
    NSLog(@"Items Removed!");
    [[Connection sharedInstance] logout:[Connection sharedInstance].username_];
}

@end
