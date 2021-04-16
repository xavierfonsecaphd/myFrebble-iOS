//
//  InvitedViewController.h
//  frebble
//
//  Created by T Test on 14/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewControllerFrebble.h"
#import "Connection.h"
#import "FrebbleConnectViewController.h"

@interface InvitedViewController : UIViewControllerFrebble

@property (strong, nonatomic) IBOutlet UIView *viewFrebbleConnect;

@property (strong, nonatomic) IBOutlet UITextField *textFieldUsername;

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) NSString *activeUsername;

- (IBAction)actionSessionStart:(id)sender;

- (IBAction)actionsessionStop:(id)sender;

@end
