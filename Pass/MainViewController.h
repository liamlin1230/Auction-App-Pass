//
//  ViewController.h
//  Pass
//
//  Created by Edward Kim on 11/27/15.
//  Copyright © 2015 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface MainViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property (weak, nonatomic) IBOutlet UICollectionView *itemCollection;

- (void)addItem:(UIImage *) image withLabel:(NSString *) label withAuthor:(NSString *) author withID:(NSString *) idKey withPrice:(NSString *) price;
-(void) clearScreen;
@end

// Allow child view controllers with a back button to home to easily access this controller
//@interface UIViewController(MainViewController)
//
//- (MainViewController*)mainViewController;
//
//@end