//
//  ViewController.m
//  Pass
//
//  Created by Edward Kim on 11/27/15.
//  Copyright © 2015 NYU. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "ItemCell.h"
#import "ItemViewController.h"

@interface MainViewController ()
{
    NSMutableArray *arrayOfLabels;
    NSMutableArray *arrayOfImages;
    NSMutableArray *arrayOfIDs;
    NSMutableArray *arrayOfAuthors;
    NSMutableArray *arrayOfPrices;
    UIRefreshControl *refreshControl;
}

@end

@implementation MainViewController {
    Firebase *ref;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ref = [[Firebase alloc] initWithUrl:@"https://incandescent-inferno-3342.firebaseio.com/"];
    
    self.title = @"pass";
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [[self itemCollection]setDataSource:self];
    [[self itemCollection]setDelegate:self];
    
    Firebase *refItems = [[Firebase alloc] initWithUrl:@"https://incandescent-inferno-3342.firebaseio.com/items"];
    
    [[[refItems queryOrderedByChild:@"startingPrice"] queryLimitedToFirst:20] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        Firebase *refSeller = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https://incandescent-inferno-3342.firebaseio.com/users/%@", snapshot.value[@"seller"]]];
        
        [refSeller observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot_seller) {
            NSLog(@"Item %@: %@ %@", snapshot.key, snapshot.value[@"name"], snapshot.value[@"startingPrice"]);
            
            // Decode base64 string to UIImage
            NSData *imageData = [[NSData alloc]initWithBase64EncodedString:snapshot.value[@"primaryPhoto"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            
            
            UIImage *image = [UIImage imageWithData:imageData];
            NSString *label = snapshot.value[@"name"];
            NSString *author = [NSString stringWithFormat:@"%@ %@", snapshot_seller.value[@"firstName"], snapshot_seller.value[@"lastName"]];
            NSString *idKey = snapshot.key;
            NSString *price = snapshot.value[@"startingPrice"];
            [self addItem:image withLabel:label withAuthor:author withID:idKey withPrice:price];
        }];
    }];
    
    UIView *refreshView = [[UIView alloc] init];
    [self.itemCollection insertSubview:refreshView atIndex:0];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor orangeColor];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [refreshView addSubview:refreshControl];
}

-(void) refresh {
    //    [self.itemCollection reloadItemsAtIndexPaths:[self.itemCollection indexPathsForVisibleItems]];
    //    [self.itemCollection reloadData];
    [refreshControl endRefreshing];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrayOfLabels count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [[cell myLabel]setText:[arrayOfLabels objectAtIndex:indexPath.item]];
    [[cell myImage]setImage:[arrayOfImages objectAtIndex:indexPath.item]];
    [[cell myAuthor]setText:[arrayOfAuthors objectAtIndex:indexPath.item]];
    [[cell myPrice]setText:[arrayOfPrices objectAtIndex:indexPath.item]];
    
    return cell;
}
- (IBAction)postItemButtonPressed:(id)sender {
    if (ref.authData) {
        // User is signed in
        [self performSegueWithIdentifier:@"postItemSegue" sender:self];
    } else {
        // Not signed in
        [self performSegueWithIdentifier:@"signinSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showItemDetail"]) {
        NSArray *indexPaths = [self.itemCollection indexPathsForSelectedItems];
        ItemViewController *destination = segue.destinationViewController;
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        destination.itemID = [arrayOfIDs objectAtIndex:indexPath.item];
        [self.itemCollection deselectItemAtIndexPath:indexPath animated:NO];
    }
}

- (void)addItem:(UIImage *) image withLabel:(NSString *) label withAuthor:(NSString *) author withID:(NSString *) idKey withPrice:(NSString *) price{
    if (!arrayOfImages) {
        arrayOfImages = [[NSMutableArray alloc] init];
        arrayOfLabels = [[NSMutableArray alloc] init];
        arrayOfAuthors = [[NSMutableArray alloc] init];
        arrayOfIDs = [[NSMutableArray alloc] init];
        arrayOfPrices = [[NSMutableArray alloc] init];
    }
    if (image != nil) {
        [arrayOfImages addObject:image];
    } else {
        [arrayOfImages addObject:[UIImage imageNamed:@"map.png"]];
    }
    //[arrayOfImages addObject:image];
    [arrayOfLabels addObject:label];
    [arrayOfAuthors addObject:author];
    [arrayOfIDs addObject:idKey];
    [arrayOfPrices addObject:price];
    [self.itemCollection reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
