//
//  InvitedViewController.m
//  frebble
//
//  Created by T Test on 14/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import "InvitedViewController.h"

@implementation InvitedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FrebbleConnectViewController* frebbleConnectViewController = [[FrebbleConnectViewController alloc] init];
    frebbleConnectViewController.view.frame = _viewFrebbleConnect.bounds;
    [self.viewFrebbleConnect addSubview:frebbleConnectViewController.view];
    [self addChildViewController:frebbleConnectViewController];
    
    self.usernameLabel.text = [Connection sharedInstance].activeUsername;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _textFieldUsername.text = [[Connection sharedInstance] partner_];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (IBAction)actionSessionStart:(id)sender
{
    [[Connection sharedInstance] sessionStart];
}

- (IBAction)actionsessionStop:(id)sender
{
    [[Connection sharedInstance] sessionStop];
}

@end
