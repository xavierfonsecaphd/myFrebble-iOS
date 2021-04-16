//
//  FrebbleViewController.m
//  frebble
//
//  Created by S. Mooij on 13/02/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import "FrebbleViewController.h"
#import "SessionViewController.h"
#import "InvitedViewController.h"
#import "InvitingViewController.h"
#import "UICKeyChainStore/UICKeyChainStore.h"

@implementation FrebbleViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    FrebbleConnectViewController* frebbleConnectViewController = [[FrebbleConnectViewController alloc] init];
    frebbleConnectViewController.view.frame = _viewFrebbleConnect.bounds;
    [self.viewFrebbleConnect addSubview:frebbleConnectViewController.view];
    [self addChildViewController:frebbleConnectViewController];
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
    _usernameLabel.text = [Connection sharedInstance].activeUsername;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
    self.usernameLabel.text = [Connection sharedInstance].activeUsername;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
}

- (IBAction)actionSessionInvite:(id)sender
{
    NSString* usernameOrEmail = [_textFieldUsernameOrEmail text];
    [[Connection sharedInstance] sessionInvite:usernameOrEmail ];
}

- (IBAction)actionLogout:(id)sender {
    [[Connection sharedInstance] sessionStop];
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    [self performSegueWithIdentifier:@"segue2Logout" sender:self];
    
    _activeUsername=@"";
    _usernameLabel.text = _activeUsername;
    
    [UICKeyChainStore removeAllItems];
    
    NSLog(@"Items Removed!");
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   NSLog(@" freeble view controller   %@",[segue identifier]);
    
}



@end
