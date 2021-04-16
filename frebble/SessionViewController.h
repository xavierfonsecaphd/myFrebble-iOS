//
//  SessionViewController.h
//  frebble
//
//  Created by T Test on 15/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "Frebble.h"
#import "FrebbleConnectViewController.h"
#import "UIViewControllerFrebble.h"

@interface SessionViewController : UIViewControllerFrebble <FrebbleDelegate>

@property (strong, nonatomic) IBOutlet UIView *viewFrebbleConnect;

@property (strong, nonatomic) IBOutlet UITextField *textFieldPartner;

- (IBAction)actionSessionStop:(id)sender;

- (IBAction)actionLogout:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;

@property (strong, nonatomic) NSString *activeUsername;

@end
