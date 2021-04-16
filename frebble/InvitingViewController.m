//
//  InvitingViewController.m
//  frebble
//
//  Created by T Test on 13/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import "InvitingViewController.h"

@implementation InvitingViewController

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
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _textfieldUsername.text = [[Connection sharedInstance] partner_];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (IBAction)buttonCancel:(id)sender
{
    [[Connection sharedInstance] sessionStop];
}

@end
