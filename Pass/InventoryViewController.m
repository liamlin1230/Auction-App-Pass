//
//  InventoryViewController.m
//  Pass
//
//  Created by Edward Kim on 11/27/15.
//  Copyright © 2015 NYU. All rights reserved.
//

#import "InventoryViewController.h"
#import "RoundOrangeButton.h"
#import "SWRevealViewController.h"

@interface InventoryViewController ()

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray * biddingList;
@property (nonatomic, strong) NSMutableArray * boughtList;
@property (nonatomic, strong) NSMutableArray * biddingPrice;
@property (nonatomic, strong) NSMutableArray * boughtPrice;
@property (nonatomic, strong) NSMutableArray * oldPriceList;
@property (nonatomic, strong) NSMutableArray * boughtDate;
@property (nonatomic, strong) RoundOrangeButton *changeBidButton;
@property UILabel *itemName;
@property UILabel *itemPrice;
@property UILabel *oldPrice;
@property UILabel *date;

@end


@implementation InventoryViewController

static NSString *CellIdentifier = @"InventoryCell";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"inventory";
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [self initArray];
    
    // Load image
    //    self.photoImageView.image = [UIImage imageNamed:self.photoFilename];
    
    
}

-(void)initArray{
    self.biddingList = [[NSMutableArray alloc]initWithObjects:@"Black Chair", @"Blue Chair", @"Broken bed",@"Fancy Desk", nil];
    self.boughtList = [[NSMutableArray alloc]initWithObjects:@"Sofa", @"Drawer", @"Cardboard Chair", nil];
    self.biddingPrice = [[NSMutableArray alloc]initWithObjects:@"$20", @"$50", @"$2",@"$100", nil];
    self.boughtPrice = [[NSMutableArray alloc]initWithObjects:@"$4", @"$10", @"$22", nil];
    self.oldPriceList = [[NSMutableArray alloc]initWithObjects:@"$15", @"$20", @"$1",@"$90", nil];
    self.boughtDate = [[NSMutableArray alloc]initWithObjects:@"Oct 28th, 2014", @"Dec 10th, 2015", @"Jan 8th, 2015", nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section){
        case 0:
            return self.biddingList.count;
            break;
        case 1:
            return self.boughtList.count;
            break;
        default:
            break;
    }
    
    return 0;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Bidding List";
            break;
        case 1:
            return @"Inventories";
            break;
        default:
            break;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //image
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(10,0, 40, 40)];
    imv.image=[UIImage imageNamed:@"bookmark.png"];
    [cell addSubview:imv];
    
    //name of item
    self.itemName = [[UILabel alloc] initWithFrame:CGRectMake(60, 2, 250, 18)];
    [self.itemName setFont:[UIFont fontWithName:@"Arial" size:12]];
    [cell.contentView addSubview:self.itemName];
    
    //price of item
    self.itemPrice = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 60, 18)];
    [self.itemPrice setFont:[UIFont fontWithName:@"Arial" size:12]];
    [cell.contentView addSubview:self.itemPrice];
    
    //date of item
    self.date = [[UILabel alloc] initWithFrame:CGRectMake(190, 5, 120, 50)];
    [self.date setFont:[UIFont fontWithName:@"Arial" size:12]];
    [cell.contentView addSubview:self.date];
    
    //old price of item
    
    switch (indexPath.section) {
        case 0:
            //change bid button
            //self.changeBidButton = [[RoundOrangeButton alloc] init];
            self.changeBidButton = [RoundOrangeButton buttonWithType:UIButtonTypeRoundedRect];
            self.changeBidButton.frame = CGRectMake(205.0f, 5.0f, 120.0f, 50.0f);
            [self.changeBidButton setTitle:@"CHANGE BID" forState:UIControlStateNormal];
            [cell addSubview:self.changeBidButton];
            [self.changeBidButton addTarget:self
                                     action:@selector(changeBid:)
                           forControlEvents:UIControlEventTouchUpInside];
            //old price of item
            self.oldPrice = [[UILabel alloc] initWithFrame:CGRectMake(60, 24, 250, 18)];
            [self.oldPrice setFont:[UIFont fontWithName:@"Arial" size:12]];
            [cell.contentView addSubview:self.oldPrice];
            
            //add bid price and item name
            self.itemName.text =[self.biddingList objectAtIndex:indexPath.row];
            self.itemPrice.textAlignment = NSTextAlignmentRight;
            self.itemPrice.text =[self.biddingPrice objectAtIndex:indexPath.row];
            self.oldPrice.text = [self.oldPriceList objectAtIndex:indexPath.row];
            break;
            
        case 1:
            self.itemName.text =[self.boughtList objectAtIndex:indexPath.row];
            self.itemPrice.textAlignment = NSTextAlignmentRight;
            self.itemPrice.text =[self.boughtPrice objectAtIndex:indexPath.row];
            
            //add bought date
            self.date.textAlignment = NSTextAlignmentRight;
            self.date.text =[self.boughtDate objectAtIndex:indexPath.row];
            break;
        default:
            break;
            
    }
    //    [self.myTableView reloadData];
    return cell;
    
}


- (IBAction)changeBid:(id)sender
{
    NSLog(@"Change Bid.");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end