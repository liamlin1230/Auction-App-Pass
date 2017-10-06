//
//  SearchViewController.h
//  Pass
//
//  Created by YouGen Lin on 12/3/15.
//  Copyright © 2015 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "ItemViewController.h"

@interface SearchViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>{
    UISearchBar *mySearchBar;
}
- (IBAction)close;

@end