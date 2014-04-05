//
//  FBLoginViewController.m
//  Ask
//
//  Created by Dinh Ho on 4/4/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import "FBLoginViewController.h"
#import <Parse/Parse.h>

@interface FBLoginViewController ()

@end

@implementation FBLoginViewController
@synthesize fbLoginView;
@synthesize fbProfileView;

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [fbLoginView setReadPermissions:@[@"basic_info"]];
//    [fbLoginView setDelegate:self];
}

//-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
//{
//    NSLog(@"logging in");
//}
//
//
//-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
//{
//    fbProfileView.profileID = user.id;
//}

//- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
//{
//    NSLog(@"logged in as ");
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonTouchHandler:(id)sender
{
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        //[_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            //[self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        } else {
            NSLog(@"User with facebook logged in!");
            //[self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        }
    }];
}

@end
