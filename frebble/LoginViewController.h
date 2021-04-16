//
//  LoginViewController.h
//  frebble
//
//  Created by T Test on 11/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewControllerFrebble.h"
#import "Connection.h"

@interface LoginViewController : UIViewControllerFrebble


@property (strong, nonatomic) IBOutlet UITextField *textFieldUsername;

@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (strong, nonatomic) IBOutlet UIButton *buttonLogin;

@property (strong, nonatomic) NSString *activeUserName;


- (IBAction)actionLogin:(id)sender;

@end
