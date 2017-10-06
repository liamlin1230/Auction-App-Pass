//
//  ItemViewController.m
//  Pass
//
//  Created by Zhegeng Wang on 12/8/15.
//  Copyright (c) 2015 NYU. All rights reserved.
//

#import "ItemViewController.h"
#import "SWRevealViewController.h"
#import "MainViewController.h"
#import "SearchViewController.h"
#import "BidItemViewController.h"
@interface ItemViewController ()

@end

@implementation ItemViewController {
    BOOL isRunning;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    BidItemViewController *second = [[BidItemViewController alloc] init];
    second.view.backgroundColor = [UIColor clearColor];
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:second animated:YES completion:nil];
    
    
    NSString *url = [NSString stringWithFormat:
                     @"https://incandescent-inferno-3342.firebaseio.com/items/%@", self.itemID];
    Firebase *refItem = [[Firebase alloc] initWithUrl: url];
    [refItem observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        Firebase *refSeller = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://incandescent-inferno-3342.firebaseio.com/users/%@", snapshot.value[@"seller"]]];
        
        [refSeller observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot_seller) {
            // load item data once
            
            // Decode base64 string to UIImage
            NSData *imageData = [[NSData alloc]initWithBase64EncodedString:snapshot.value[@"primaryPhoto"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            self.itemImageView.image = [UIImage imageWithData:imageData];
            
            self.itemNameLabel.text = snapshot.value[@"name"];
            self.itemDescriptionTextView.text = snapshot.value[@"description"];
            self.sellerNameLabel.text = [NSString stringWithFormat:@"%@ %@", snapshot_seller.value[@"firstName"], snapshot_seller.value[@"lastName"]];
            self.currentBidLabel.text = snapshot.value[@"currentBid"];
            [self.buyoutButton setTitle: [NSString stringWithFormat:@"BUY NOW %@", snapshot.value[@"buyoutPrice"]] forState: UIControlStateNormal];
            self.expirationDate = snapshot.value[@"expirationDate"];
            isRunning = YES;
            [self performSelector:@selector(updateCountdown) withObject:nil afterDelay:0];
        }];
    }];
    
    
    //self.itemImageView.image = [UIImage imageNamed:self.itemImageName];
    NSString *formattedStr = [NSString stringWithFormat:@"Item ID: %@", self.itemID];
    NSLog(@"%@", formattedStr);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    
    UINavigationBar *myNav = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    [myNav setBackgroundImage:[UIImage new]
                forBarMetrics:UIBarMetricsDefault];
    myNav.shadowImage = [UIImage new];
    myNav.translucent = YES;
    [self.view addSubview:myNav];
    
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(close)];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-search"] style:UIBarButtonItemStylePlain target:self action:@selector(goToSearch)];
    searchItem.imageInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    
//    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithTitle:@"Search"
//                                                                   style:UIBarButtonItemStylePlain
//                                                                  target:self action:@selector(goToSearch)];
    
    
    UINavigationItem *navigItem = [[UINavigationItem alloc] init];
    navigItem.rightBarButtonItem = searchItem;
    navigItem.leftBarButtonItem = cancelItem;
    myNav.items = [NSArray arrayWithObjects: navigItem,nil];
    
    [UIBarButtonItem appearance].tintColor = [UIColor whiteColor];
    
    
}

- (IBAction)close {
    isRunning = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goToSearch{
    SearchViewController *s = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    [self presentViewController:s animated:YES completion:nil];
    
}

- (void)updateCountdown {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSDate *startingDate = [NSDate date];
    NSDate *endingDate = [dateFormatter dateFromString:self.expirationDate];;
    NSString *countdownText;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:startingDate toDate:endingDate options:0];
    
    NSInteger days     = [dateComponents day];
    NSInteger months   = [dateComponents month];
    NSInteger years    = [dateComponents year];
    NSInteger hours    = [dateComponents hour];
    NSInteger minutes  = [dateComponents minute];
    NSInteger seconds  = [dateComponents second];
    
    //NSLog(@"days: %d, hours: %d, minutes: %d, seconds: %d", (int)days, (int)hours, (int)minutes, (int)seconds);
    
    if (!(int)years && (int)months != 0 && (int)days != 0) {
        countdownText = [NSString stringWithFormat:@"%ldM %ldd %ldh %ldm %lds",
                        (long)months, (long)days, (long)hours, (long)minutes, (long)seconds];
    } else if (!(int)months && (int)days != 0) {
        countdownText = [NSString stringWithFormat:@"%ldd %ldh %ldm %lds",
                         (long)days, (long)hours, (long)minutes, (long)seconds];
    } else if (!(int)days && (int)hours != 0) {
        countdownText = [NSString stringWithFormat:@"%ldh %ldm %lds",
                         (long)hours, (long)minutes, (long)seconds];
    } else if (!(int)hours) {
        countdownText = [NSString stringWithFormat:@"%ldm %lds",
                         (long)minutes, (long)seconds];
    } else if (!(int)minutes) {
        countdownText = [NSString stringWithFormat:@"%lds",
                         (long)seconds];
    } else {
        countdownText = [NSString stringWithFormat:@"%ldy %ldm %ldd %ldh %ldm %lds",
                         (long)years, (long)months, (long)days, (long)hours, (long)minutes, (long)seconds];
    }
    self.timeLeftLabel.text = countdownText;
    
    if (isRunning) {
        [self performSelector:@selector(updateCountdown) withObject:nil afterDelay:1];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end