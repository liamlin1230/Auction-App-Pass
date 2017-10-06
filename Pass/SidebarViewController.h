//
//  SidebarViewController.h
//  Pass
//
//  Created by Edward Kim on 11/27/15.
//  Copyright © 2015 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface SidebarViewController : UITableViewController

- (void)handleHideSidebarTimer:(NSTimer*)theTimer;

@end