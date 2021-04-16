//
//  UIViewControllerDismissKeyboard
//  frebble
//
//  Created by S. Mooij on 11/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import "UIViewControllerFrebble.h"
#import "SessionViewController.h"

@implementation UIViewControllerFrebble

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"balletjes.png"]];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [[Connection sharedInstance] addDelegate:self];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    [[Connection sharedInstance] removeDelegate:self];
}

- (void) dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void) didMessageServerLoginSucces:(NSString*)username
{
    [self performSegueWithIdentifier:@"segue2Frebble" sender:self];
}

- (void) didMessageServerSessionInvite:(NSString *)partner
{
    [self performSegueWithIdentifier:@"segue2Invited" sender:self];
}

- (void) didMessageServerSessionInviting:(NSString *)partner
{
    [self performSegueWithIdentifier:@"segue2Inviting" sender:self];
}

- (void) didMessageServerSessionStart:(NSString *)partner
{
    [self performSegueWithIdentifier:@"segue2Frebbling" sender:self];
}

- (void) didMessageServerSessionValue:(int)value
{
    [[Frebble sharedInstance] setPressure:value];
}

- (void) didMessageSimple:(int)message
{
    switch (message)
    {
        case MESSAGE_SERVER_CREATE_USER_SUCCESS:
        {
            [[[UIAlertView alloc] initWithTitle:@"Success" message:@"User created." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            [self performSegueWithIdentifier:@"segue2Login" sender:self];
            break;
        }
        case MESSAGE_SERVER_CREATE_USER_ERROR_USERNAME:
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Username already in use." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            break;
        }
        case MESSAGE_SERVER_CREATE_USER_ERROR_EMAIL:
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Email already in use." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            break;
        }
        case MESSAGE_SERVER_LOGIN_ERROR:
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong username, email or password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            break;
        }
        case MESSAGE_SERVER_SESSION_PARTNER_OFFLINE:
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"The person you are trying to frebble is not logged in." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            break;
        }
        case MESSAGE_SERVER_SESSION_PARTNER_NOTEXIST:
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"The person you are trying to frebble is unknown." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            break;
        }
        case MESSAGE_SERVER_SESSION_PARTNER_BUSY:
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"The person you are trying to frebble is already frebbling someone else." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            break;
        }
        case MESSAGE_SERVER_SESSION_STOP:
        {
            [[Frebble sharedInstance] setPressure:0];
            NSLog(@"MESSAGE_SERVER_SESSION_STOP received");
            [self performSegueWithIdentifier:@"segueStopSession" sender:self];

            
            break;
        }
        // Logout button
        case -100:
        {
            [[Frebble sharedInstance] setPressure:0];
            //            [self performSegueWithIdentifier:@"segueUnwind2Frebble" sender:self];
            [self performSegueWithIdentifier:@"segue2Logout" sender:self];

        }
        default:
        {
            [self performSegueWithIdentifier:@"segueStopSession" sender:self];
            break;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"UI View Controller:   %@",[segue identifier]);
}

- (void) didConnectionLost
{
    [[Frebble sharedInstance] setPressure:0];
//    [self performSegueWithIdentifier:@"segueStopSession" sender:self];
//    [self performSegueWithIdentifier:@"segue2Frebble" sender:self];
}

@end