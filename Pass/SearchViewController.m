//
//  SearchViewController.m
//  Pass
//
//  Created by YouGen Lin on 12/3/15.
//  Copyright © 2015 NYU. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

//@property (nonatomic, strong) NSMutableArray * initialCities;
//@property (nonatomic, strong) NSMutableArray * peopleNames;
//@property (nonatomic, strong) NSMutableArray * filteredCities;
//@property (nonatomic, strong) NSMutableArray * filteredPeople;

@property (nonatomic, strong) NSMutableDictionary *itemsList;
@property (nonatomic, strong) NSMutableDictionary *usersList;
@property (nonatomic, strong) NSMutableArray * filteredItems;
@property (nonatomic, strong) NSMutableArray * filteredUsers;

@property BOOL isFiltered;
@property UILabel *itemLabel;

@end

@implementation SearchViewController

static NSString *CellIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.itemsList = [[NSMutableDictionary alloc] init];
    self.usersList = [[NSMutableDictionary alloc] init];
    
    Firebase *refItems = [[Firebase alloc] initWithUrl:@"https://incandescent-inferno-3342.firebaseio.com/items"];
    Firebase *refUsers = [[Firebase alloc] initWithUrl:@"https://incandescent-inferno-3342.firebaseio.com/users"];
    
    // Limited to 500 items for now
    [[[refItems queryOrderedByChild:@"startingPrice"] queryLimitedToFirst:500] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        [self.itemsList setObject:snapshot.key
                           forKey:snapshot.value[@"name"]];
    }];
    
    // Limited to 100 items for now
    [[[refUsers queryOrderedByChild:@"lastName"] queryLimitedToFirst:100] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        [self.usersList setObject:snapshot.key
                           forKey:[NSString stringWithFormat:@"%@ %@", snapshot.value[@"firstName"], snapshot.value[@"lastName"]]];
    }];
}


-(void) viewWillAppear:(BOOL)animated {
    
    UINavigationBar *myNav = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    [self.view addSubview:myNav];
    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    mySearchBar.delegate = self;
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(close)];
    UINavigationItem *navigItem = [[UINavigationItem alloc] init];
    
    navigItem.leftBarButtonItem = cancelItem;
    navigItem.titleView = mySearchBar;
    myNav.items = [NSArray arrayWithObjects: navigItem,nil];
    
    [cancelItem setWidth:100];
    
    [UIBarButtonItem appearance].tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isFiltered == YES)
    {
        switch (section){
            case 0:
                return self.filteredItems.count;
                break;
            case 1:
                return self.filteredUsers.count;
                break;
            default:
                break;
        }
    }
    
    
    return 0;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Items";
            break;
        case 1:
            return @"People";
            break;
        default:
            break;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    self.itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0 , 250, 40)];
    [self.itemLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [cell.contentView addSubview:self.itemLabel];
    
    //image
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(10,0, 40, 40)];
    imv.image=[UIImage imageNamed:@"bookmark.png"];
    [cell addSubview:imv];
    
    // Reload cell
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    // get the object of the key
    // [self.itemsList objectForKey:[itemsKeys objectAtIndex:indexPath.row]]
    
    if (self.isFiltered == YES) {
        switch (indexPath.section) {
            case 0:
                //self.itemName.text = [self.filteredCities objectAtIndex:indexPath.row];
                //NSArray *itemValue = [self.itemsList objectForKey:[itemsKeys objectAtIndex:indexPath.row]];
                //self.itemName.text = [itemValue objectAtIndex:0];
                //self.itemLabel.text = [self.filteredItems objectAtIndex:indexPath.row];
                cell.textLabel.text = [self.filteredItems objectAtIndex:indexPath.row];
                break;
            case 1:
                //self.itemName.text = [self.filteredPeople objectAtIndex:indexPath.row];
                //NSArray *userValue = [self.usersList objectForKey:[usersKeys objectAtIndex:indexPath.row]];
                //self.itemName.text = [userValue objectAtIndex:0];
                //self.itemLabel.text = [self.filteredUsers objectAtIndex:indexPath.row];
                cell.textLabel.text = [self.filteredUsers objectAtIndex:indexPath.row];
                break;
            default:
                break;
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 4;
}

//#pragme mark -
//#pragma mark UISearchBarDelegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *searchString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (searchText.length == 0 || searchString.length == 0) {
        self.isFiltered = NO;
    } else {
        self.isFiltered = YES;
        
        self.filteredItems = [[NSMutableArray alloc] init];
        self.filteredUsers = [[NSMutableArray alloc] init];
        
        NSArray *itemKeys = [self.itemsList allKeys];
        NSArray *userKeys = [self.usersList allKeys];
        
        for (NSString *itemName in itemKeys) {
            NSRange itemNameRange = [itemName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (itemNameRange.location != NSNotFound) {
                [self.filteredItems addObject:itemName];
            }
        }
        
        for (NSString *userName in userKeys) {
            NSRange userNameRange = [userName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (userNameRange.location != NSNotFound) {
                [self.filteredUsers addObject:userName];
            }
        }
        
    }
    
//    Reload our table view
//        [self.myTableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    if ([self.filteredItems containsObject:cellText]) {
        [self performSegueWithIdentifier:@"showItemDetail" sender:self];
    }
    else if ([self.filteredUsers containsObject:cellText]) {
        //      [self performSegueWithIdentifier:@"showPeopleDetail" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showItemDetail"]) {
        ItemViewController *destination = segue.destinationViewController;
        NSArray *indexPaths = [self.myTableView indexPathsForSelectedRows];
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        
        UITableViewCell *selectedCell = [self.myTableView cellForRowAtIndexPath:indexPath];
        NSString *cellText = selectedCell.textLabel.text;
        
        destination.itemID = [self.itemsList objectForKey:cellText];
        
        [self.myTableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    else if ([segue.identifier isEqualToString:@"showPeopleDetail"]){
        
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [mySearchBar resignFirstResponder];
    [self.myTableView reloadData];
}

- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end