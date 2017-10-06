//
//  SidebarViewController.m
//  Pass
//
//  Created by Edward Kim on 11/27/15.
//  Copyright © 2015 NYU. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"

@interface SidebarViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation SidebarViewController {
    NSArray *menuItems;
    Firebase *ref;
//    Firebase *refUsers;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ref = [[Firebase alloc] initWithUrl:@"https://incandescent-inferno-3342.firebaseio.com/"];
//    refUsers = [[Firebase alloc] initWithUrl: @"https://incandescent-inferno-3342.firebaseio.com/users"];
    menuItems = @[@"title", @"notifications", @"inventory", @"settings", @"help", @"termsandprivacy", @"logout"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Asynchronous authentication checker
    [ref observeAuthEventWithBlock:^(FAuthData *authData) {
        switch (indexPath.row) {
            case 0: {
                UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
                if (authData) {
                    // user authenticated
                    NSString *url = [NSString stringWithFormat:
                                     @"https://incandescent-inferno-3342.firebaseio.com/users/%@", authData.uid];
                    Firebase *refUser = [[Firebase alloc] initWithUrl: url];
                    [refUser observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                        // load user data once
                        titleLabel.text = [NSString stringWithFormat:
                                           @"%@ %@", snapshot.value[@"firstName"], snapshot.value[@"lastName"]];
                    }];
                } else {
                    // No user is signed in
                    titleLabel.text = @"Sign In";
                }
            }
                break;
            case 6: {
                UILabel *logoutLabel = (UILabel *)[cell viewWithTag:2];
                if (authData) {
                    // user authenticated
                    logoutLabel.text = @"Logout";
                } else {
                    // No user is signed in
                    logoutLabel.text = @" ";
                }
            }
                break;
        }
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ref.authData) {
        // user authenticated
        switch(indexPath.row) {
            case 0:
                //[self performSegueWithIdentifier:@"profileSegue" sender:self];
                break;
            case 1:
                [self performSegueWithIdentifier:@"notificationsSegue" sender:self];
                break;
            case 2:
                [self performSegueWithIdentifier:@"inventorySegue" sender:self];
                break;
            case 3:
                [self performSegueWithIdentifier:@"settingsSegue" sender:self];
                break;
            case 4:
                [self performSegueWithIdentifier:@"helpSegue" sender:self];
                break;
            case 5:
                [self performSegueWithIdentifier:@"termsAndPrivacySegue" sender:self];
                break;
            case 6:
                // Logout
                [ref unauth];
                [self.revealViewController revealToggleAnimated:YES];
                break;
        }
    } else {
        // No user is signed in, set segues to signinViewController
        if (indexPath.row != 6)
            [self performSegueWithIdentifier:@"signinSegue" sender:self];
        
    }
    
}

- (void)handleHideSidebarTimer:(NSTimer*)theTimer {
    
    // Close the sidebar menu
    [self.revealViewController revealToggleAnimated:[theTimer userInfo]];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"signinSegue"]) {
        // Set timer to close sidebar menu so it doesn't happen as you segue modally
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(handleHideSidebarTimer:)
                                       userInfo:NO
                                        repeats:NO];
    }
}

@end
