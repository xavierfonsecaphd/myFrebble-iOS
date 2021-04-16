//
//  InvitingViewController.h
//  frebble
//
//  Created by T Test on 13/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "FrebbleConnectViewController.h"
#import "UIViewControllerFrebble.h"

@interface InvitingViewController : UIViewControllerFrebble

@property (strong, nonatomic) IBOutlet UIView *viewFrebbleConnect;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;

@property (strong, nonatomic) IBOutlet UITextField *textfieldUsername;

- (IBAction)buttonCancel:(id)sender;

@end
