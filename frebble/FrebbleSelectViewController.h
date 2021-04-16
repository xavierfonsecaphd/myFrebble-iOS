//
//  FrebbleSelectViewController.h
//  frebble
//
//  Created by T Test on 27/02/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Frebble.h"
#import "Connection.h"
#import "UIViewControllerFrebble.h"

@interface FrebbleSelectViewController : UIViewControllerFrebble <UITableViewDelegate, UITableViewDataSource, FrebbleDelegate>

@property (strong, nonatomic) IBOutlet UITableView *table;

- (IBAction)actionSelect:(id)sender;

- (IBAction)actionCancel:(id)sender;

@end
