//
//  FriendsTableViewController.h
//  Ask
//
//  Created by Derrick J Chie on 4/5/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
{
    UIImage *emptyImage;
    UIImage *selectedImage;
    
    NSMutableDictionary *userNameDictionary; // this is a temporary proof of concept 
}
@property(nonatomic, strong)NSArray *friends;
@property IBOutlet UISearchBar *friendSearchBar;
@property(nonatomic, strong)NSMutableArray *filteredFriends;
@property(nonatomic, strong)NSMutableArray *selectedFriendsArray;
@property(nonatomic, strong)NSData *takenImage;
@property(nonatomic, strong)NSString *question;

@end
