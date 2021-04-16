//
//  CreateAccountViewController.h
//  Frebble
//
//  Created by Francisco Xavier on 29/10/15.
//  Copyright © 2015 HollandHaptics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewControllerFrebble.h"
#import "Connection.h"

@interface CreateAccountViewController : UIViewControllerFrebble

@property (strong, nonatomic) IBOutlet UITextField *textFieldUsername;

@property (strong, nonatomic) IBOutlet UITextField *textfieldEmail;

@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (strong, nonatomic) IBOutlet UIButton *buttonCreateUser;

- (IBAction)actionCreateUser:(id)sender;

@end
