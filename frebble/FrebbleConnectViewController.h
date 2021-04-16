//
//  FrebbelConnectViewController.h
//  frebble
//
//  Created by T Test on 16/03/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Frebble.h"
#import "FrebbleViewController.h"

@interface FrebbleConnectViewController : UIViewController <FrebbleDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textFieldStatus;

@property (strong, nonatomic) IBOutlet UIButton *buttonConnect;

- (IBAction)actionSelect:(id)sender;

- (IBAction)actionConnect:(id)sender;

@end