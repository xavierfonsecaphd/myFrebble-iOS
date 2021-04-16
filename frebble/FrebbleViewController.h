//
//  FrebbleViewController.h
//  frebble
//
//  Created by S. Mooij on 13/02/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "UIViewControllerFrebble.h"
#import "defaults.h"
#import "FrebbleConnectViewController.h"

@interface FrebbleViewController : UIViewControllerFrebble

@property (strong, nonatomic) IBOutlet UIView *viewFrebbleConnect;

@property (strong, nonatomic) IBOutlet UITextField *textFieldUsernameOrEmail;

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;

@property (strong, nonatomic) NSString *activeUsername;

- (IBAction)actionSessionInvite:(id)sender;


- (IBAction)actionLogout:(id)sender;


@end
