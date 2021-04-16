//
//  LoginViewController.m
//  frebble
//
//  Created by T Test on 11/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import "LoginViewController.h"
#import "FrebbleViewController.h"
#import "UICKeyChainStore/UICKeyChainStore.h"

@implementation LoginViewController



- (void)viewWillAppear:(BOOL)animated
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    NSString *usernameStored = [store stringForKey:@"username"];
    NSString *passwordStored = [store stringForKey:@"password"];
    
    
    
    if (!((usernameStored == nil) || (passwordStored == nil)))
    {
        NSLog(@"Username stored:  %@",usernameStored);
        NSLog(@"password stored:  %@",passwordStored);

        self.activeUserName = usernameStored;
        [[Connection sharedInstance] login:usernameStored passwordhash:passwordStored];
        [[Connection sharedInstance] setActiveUsername:usernameStored];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;

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

- (IBAction)actionLogin:(id)sender
{
   
    NSString* username = [_textFieldUsername text];
    NSString* password = [_textFieldPassword text];
    if ([username length] == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Username needed for login." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        
    }
    else
    {
        
        if ([password length] == 0)
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Password needed for login." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        else
        {
            [[Connection sharedInstance] login:username passwordhash:password];
            [[Connection sharedInstance] setActiveUsername:username];
            self.activeUserName = username;
                
            [UICKeyChainStore setString:username forKey:@"username"];
            [UICKeyChainStore setString:password forKey:@"password"];
            
        }
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier  isEqual: @"segue2Frebble"])
    {
        
        if ([[segue identifier] isEqualToString:@"segue2Frebble"]) {
            UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
            FrebbleViewController *myVC = [[navigationController viewControllers] lastObject];
            [myVC setActiveUsername:self.activeUserName];
        }
    }
    
    if ([segue.identifier  isEqual: @"segue2Inviting"])
    {
        NSLog(@"Entrou no prepareForSegue no login view controller");
    }
    
}


@end
