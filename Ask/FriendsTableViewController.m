//
//  FriendsTableViewController.m
//  Ask
//
//  Created by Derrick J Chie on 4/5/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "Globals.h"
#import "UIViewController+ECSlidingViewController.h"
#import "FacebookFriend.h"
#import "FriendTableViewCell.h"

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController
@synthesize friends;
@synthesize friendSearchBar;
@synthesize filteredFriends;
@synthesize selectedFriendsArray;


- (void)viewDidLoad
{
    [super viewDidLoad];
    selectedImage = [UIImage imageNamed:@"RadioButtonBlue.png"];
    emptyImage = [UIImage imageNamed:@"RadioButtonEmpty.png"];
    selectedFriendsArray = [[NSMutableArray alloc] init];
    UINib *nib = [UINib nibWithNibName:@"FriendTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"FriendTableViewCell"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for(id key in [Globals sharedGlobals].friendsDictionary)
    {
        [temp addObject:[[Globals sharedGlobals].friendsDictionary objectForKey:key]];
    }
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    friends = [[NSArray alloc] init];
    friends = [temp sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    filteredFriends = [NSMutableArray arrayWithCapacity:[friends count]];
    friendSearchBar.delegate = self;
    [self.tableView reloadData];


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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredFriends count];
    } else {
        return [friends count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"FriendTableViewCell";
    FriendTableViewCell *cell = (FriendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellName];
    
    //cell.textLabel.text = [friends objectAtIndex:indexPath.row];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.friendLabel.text = [filteredFriends objectAtIndex:indexPath.row];
    } else {
        cell.friendLabel.text = [friends objectAtIndex:indexPath.row];
    }
    // Configure the cell...
    
    return cell;
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    [filteredFriends removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
    filteredFriends = [NSMutableArray arrayWithArray:[friends filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendTableViewCell *cell = (FriendTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell.friendSelected)
    {
        cell.friendSelected = true;
        cell.selectImage.image = selectedImage;
        [selectedFriendsArray addObject:cell.friendLabel.text];
       // [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }
    else
    {
        cell.friendSelected = false;
        cell.selectImage.image = emptyImage;
        [selectedFriendsArray removeObject:cell.friendLabel.text];
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
@end
