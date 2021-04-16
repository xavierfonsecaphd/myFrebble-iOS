//
//  FrebbelConnectViewController.m
//  frebble
//
//  Created by T Test on 16/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import "FrebbleConnectViewController.h"

@implementation FrebbleConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    
    
    /*
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];*/
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"balletjes.png"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [[Frebble sharedInstance] addDelegate:self];
    [self updateView];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [[Frebble sharedInstance] removeDelegate:self];
}

- (void) didDiscover: (NSString*) identifier
{
}

- (void) didConnect
{
    NSLog(@"FrebbleConnectViewController.h didConnect {");
    @synchronized (self)
    {
        [self updateView];
    }
    NSLog(@"FrebbleConnectViewController.h didConnect }");
}

- (void) didDisconnect
{
    @synchronized (self)
    {
        [self updateView];
    }
}

- (void) didUpdatePressure:(int)value
{
}

- (void) updateView
{
    if ([[Frebble sharedInstance] shouldBeConnected])
    {
        if ([[Frebble sharedInstance] isConnected])
        {
            _textFieldStatus.text = [NSString stringWithFormat:@"Connected to: %@", [[Frebble sharedInstance] selected]];
            [_buttonConnect setTitle: @"Disconnect" forState:UIControlStateNormal];
        }
        else
        {
            _textFieldStatus.text = @"Connecting...";
            [_buttonConnect setTitle: @"Cancel" forState:UIControlStateNormal];
        }
    }
    else
    {
        if ([[Frebble sharedInstance] isConnected])
        {
            _textFieldStatus.text = @"Disconnecting...";
        }
        else
        {
            if ([[Frebble sharedInstance] selected] == nil)
            {
                _textFieldStatus.text = @"Not connected";
            }
            else
            {
                _textFieldStatus.text = [NSString stringWithFormat:@"Not connected to: %@", [[Frebble sharedInstance] selected]];
            }
            [_buttonConnect setTitle: @"Connect" forState:UIControlStateNormal];
        }
    }
}

- (IBAction)actionSelect:(id)sender
{
    if ([self.parentViewController isKindOfClass: [FrebbleViewController class]])
    {
        if ([[Frebble sharedInstance] shouldBeConnected])
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please disconnect Frebble first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        else
        {
            [self.parentViewController performSegueWithIdentifier:@"segue2FrebbleSelect" sender:sender];
        }
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please stop session first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

- (IBAction)actionConnect:(id)sender
{
    @synchronized (self)
    {
        if ([[Frebble sharedInstance] shouldBeConnected])
        {
            [[Frebble sharedInstance] disConnect];
        }
        else
        {
            if (![[Frebble sharedInstance] connect])
            {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select a Frebble first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        }
        [self updateView];
    }
}

@end
