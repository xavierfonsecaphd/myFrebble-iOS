//
//  CreateAccountViewController.m
//  Frebble
//
//  Created by Francisco Xavier on 29/10/15.
//  Copyright © 2015 HollandHaptics. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "LoginViewController.h"

//
//  LoginViewController.m
//  frebble
//
//  Created by T Test on 11/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

@implementation CreateAccountViewController




- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


- (IBAction)actionCreateUser:(id)sender
{
    NSString* username = [_textFieldUsername text];
    NSString* email = [_textfieldEmail text];
    NSString* password = [_textFieldPassword text];
    if ([username length] == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Username cannot be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else
    {
        if ([email length] == 0)
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Email cannot be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        else
        {
            if ([password length] == 0)
            {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Password cannot be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
            else
            {
                if (![email containsString:@"@"])
                {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Email must contain '@' charcter." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                }
                else
                {
                    [[Connection sharedInstance] create:username email:email passwordhash:password];
                    

//                    [self performSegueWithIdentifier:@"segue2Login" sender:self];
                } //loginView
            }
        }
    }
}



@end
