//
//  FBLoginViewController.m
//  Ask
//
//  Created by Dinh Ho on 4/4/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import "FBLoginViewController.h"

@interface FBLoginViewController ()

@end

@implementation FBLoginViewController
@synthesize fbLoginView;
@synthesize fbProfileView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [fbLoginView setReadPermissions:@[@"basic_info"]];
    [fbLoginView setDelegate:self];
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSLog(@"logging in");
}


-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    fbProfileView.profileID = user.id;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"logged in as ");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
