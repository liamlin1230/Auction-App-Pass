//
//  InventoryViewController.h
//  Pass
//
//  Created by Edward Kim on 11/27/15.
//  Copyright © 2015 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) NSString *photoFilename;
@end
