//
//  ItemViewController.h
//  Pass
//
//  Created by Zhegeng Wang on 12/8/15.
//  Copyright (c) 2015 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "TransparentWhiteButton.h"

@interface ItemViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) NSString *itemImageName;
@property (weak, nonatomic) NSString *itemName;
@property (weak, nonatomic) NSString *itemID;

@property (weak, nonatomic) NSString *expirationDate;

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *itemDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentBidLabel;
@property (weak, nonatomic) IBOutlet TransparentWhiteButton *buyoutButton;


-(IBAction)close;
-(IBAction)goToSearch;

@end
