//
//  FrebbleSelectViewController.m
//  frebble
//
//  Created by T Test on 27/02/15.
//  Copyright (c) 2015 HollandHaptics. All rights reserved.
//

#import "FrebbleSelectViewController.h"

@implementation FrebbleSelectViewController

NSMutableArray* frebbles;

- (void)viewDidLoad
{
    NSLog(@"FrebbleSelectViewController viewDidLoad {");
    [super viewDidLoad];
    NSLog(@"FrebbleSelectViewController viewDidLoad }");
}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"FrebbleSelectViewController viewDidAppear {");
    [super viewDidAppear:animated];
    @synchronized(self)
    {
        frebbles = [[NSMutableArray alloc] init];
        _table.delegate = self;
        _table.dataSource = self;
        [[Frebble sharedInstance] addDelegate:self];
        [[Frebble sharedInstance] disConnect];
        [[Frebble sharedInstance] startScanning];
        [_table reloadData];
    }
    NSLog(@"FrebbleSelectViewController viewDidAppear }");
}

- (void) viewDidDisappear:(BOOL)animated
{
    NSLog(@"FrebbleSelectViewController viewDidDisappear {");
    [super viewDidDisappear:animated];
    @synchronized(self)
    {
        [[Frebble sharedInstance] removeDelegate:self];
        [[Frebble sharedInstance] stopScanning];
    }
    NSLog(@"FrebbleSelectViewController viewDidDisappear }");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    return [frebbles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* tableIdentifier = @"Frebbles";
    UITableViewCell* result = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (result == nil)
    {
        result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
    }
    result.textLabel.text = [frebbles objectAtIndex:[indexPath row]];
    result.textLabel.font = [UIFont systemFontOfSize:14];
    return result;
}

- (void) didDiscover:(NSString *)identifier
{
    NSLog(@"FrebbleSelectViewController didDiscover: %@ {", identifier);
    @synchronized(self)
    {
        if (![frebbles containsObject:identifier])
        {
            NSLog(@"addObject: %@", identifier);
            [frebbles addObject: identifier];
            [_table reloadData];
        }
    }
    NSLog(@"FrebbleSelectViewController didDiscover: %@ }", identifier);
}

- (void) didConnect
{
}

- (void) didDisconnect
{
}

- (void) didUpdatePressure:(int) value
{
}

- (IBAction)actionSelect:(id)sender
{
    NSIndexPath* nsIndexPath = [_table indexPathForSelectedRow];
    if (nsIndexPath != nil)
    {
        NSString* identifier = [frebbles objectAtIndex:[nsIndexPath row]];
        [[Frebble sharedInstance] select:identifier];
        NSLog(@"Selected: %@", identifier);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
