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
#import <Parse/Parse.h>
#import "Constants.h"
#import "LoadingService.h"

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController
@synthesize friends;
@synthesize friendSearchBar;
@synthesize filteredFriends;
@synthesize selectedFriendsArray;
@synthesize takenImage;
@synthesize question;


- (void)viewDidLoad
{
    [super viewDidLoad];
    userNameDictionary = [[NSMutableDictionary alloc] init];
    
    [userNameDictionary setObject:@"9rycr1uykd1c3ywsske9ozc84" forKey:@"Dinh Ho"];
    [userNameDictionary setObject:@"yanokb8famv0e5iw706ej1b3h" forKey:@"Darri Cheez"];
    [userNameDictionary setObject:@"a2s1s0e1w1fby152aorl4df4s" forKey:@"David Chung"];
    
    selectedImage = [UIImage imageNamed:@"RadioButtonBlue.png"];
    emptyImage = [UIImage imageNamed:@"RadioButtonEmpty.png"];
    selectedFriendsArray = [[NSMutableArray alloc] init];
    UINib *nib = [UINib nibWithNibName:@"FriendTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"FriendTableViewCell"];
    [self.searchDisplayController.searchResultsTableView registerNib:nib forCellReuseIdentifier:@"FriendTableViewCell"];

    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for(id key in [Globals sharedGlobals].friendsDictionary)
    {
        [temp addObject:[[Globals sharedGlobals].friendsDictionary objectForKey:key]];
    }
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    friends = [[NSArray alloc] init];
    //friends = [temp sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    friends = [NSArray arrayWithObjects:@"Dinh Ho", @"David Chung", @"Darri Cheez", nil];
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
    if (!cell)
    {
        cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendTableViewCell"];
    }
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

- (IBAction)nextButtonHandler:(id)sender
{
    if (selectedFriendsArray.count == 0)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select atleast 1 friend" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    else
    {
        [[LoadingService sharedLoadingService] startLoading:self.view];
        if (selectedFriendsArray.count > 1)
        {
            for (int i = 0; i < selectedFriendsArray.count; ++i)
            {
                PFFile *imageFile = [PFFile fileWithName:@"taken_image.png" data:takenImage];
                PFObject *questionObject = [PFObject objectWithClassName:kQuestionClassName];
                questionObject[kAnswered] = [NSNumber numberWithBool:false];
                questionObject[kType] = [NSNumber numberWithInt:1];
                questionObject[kResponse] = [NSNumber numberWithInt:0];
                questionObject[kImageName] = imageFile;
                questionObject[kRecipient] = [selectedFriendsArray objectAtIndex:i];
                questionObject[kQuestionText] = question;
                questionObject[kCreatedBy] = [Globals sharedGlobals].userData[@"name"];
                if (i != selectedFriendsArray.count -1)
                {
                    [questionObject saveInBackground];
                }
                else
                {
                    [questionObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        [[LoadingService sharedLoadingService] stopLoading:self.view];
                    }];
                }
                
                
            }
        }
        else if (selectedFriendsArray.count == 1)
        {
            PFFile *imageFile = [PFFile fileWithName:@"taken_image.png" data:takenImage];
            PFObject *questionObject = [PFObject objectWithClassName:kQuestionClassName];
            questionObject[kAnswered] = [NSNumber numberWithBool:false];
            questionObject[kCreatedBy] = [[PFUser currentUser] username];
            questionObject[kType] = [NSNumber numberWithInt:1];
            questionObject[kResponse] = [NSNumber numberWithInt:0];
            questionObject[kImageName] = imageFile;
            questionObject[kQuestionText] = question;
            NSString *friend = [selectedFriendsArray objectAtIndex:0];
            if ([userNameDictionary objectForKey:friend])
            {
                questionObject[kRecipient] =  [userNameDictionary objectForKey:friend];
            }
            else
            {
                questionObject[kRecipient] = @"9rycr1uykd1c3ywsske9ozc84";//[selectedFriendsArray objectAtIndex:0];

            }
            [questionObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
            {
                [[LoadingService sharedLoadingService] stopLoading:self.view];
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Question was asked" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
                [self.navigationController popToRootViewControllerAnimated:true];
                
            }];
            
        }
    }
    [selectedFriendsArray removeAllObjects];


}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
@end
