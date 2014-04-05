//
//  FriendsTableViewController.h
//  Ask
//
//  Created by Derrick J Chie on 4/5/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property(nonatomic, strong)NSArray *friends;
@property IBOutlet UISearchBar *friendSearchBar;
@property(nonatomic, strong)NSMutableArray *filteredFriends;

@end
