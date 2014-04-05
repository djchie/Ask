//
//  HomeViewController.m
//  Ask
//
//  Created by Dinh Ho on 4/4/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import "HomeViewController.h"
#import <Parse/Parse.h>
#import "UIViewController+ECSlidingViewController.h"
#import "FacebookFriend.h"
#import "Globals.h"
#import "LoadingService.h"

#define kSegueFromHomeToCamera @"homeToCamera"

@interface HomeViewController ()

@end

@implementation HomeViewController



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self.loginView setBackgroundColor:[UIColor colorWithRed:133/255.0 green:210/255.0 blue:190/255.0 alpha:1.0]];
    
    [self.view setBackgroundColor:[UIColor redColor]];
    
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        // Push the next view controller without animation
        // Handle all the log-in view stuff
       // [self loadUserInformation];

        [self hideLoginView];
        

    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    
}
-(void)loadComplete
{
//    [[LoadingService sharedLoadingService] stopLoading:self.view];
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
}

-(void)hideLoginView
{
    self.loginView.hidden = true;
    if ([Globals sharedGlobals].userData)
    {
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginButtonTouchHandler:(id)sender
{
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location",@"read_friendlists"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error)
     {
         MenuViewController *vc = [self getMenuViewController];

         if (!user)
         {
             if (!error) {
                 NSLog(@"Uh oh. The user cancelled the Facebook login.");
             } else {
                 NSLog(@"Uh oh. An error occurred: %@", error);
             }
         } else if (user.isNew) {
             NSLog(@"User with facebook signed up and logged in!");
             //[self loadUserInformation];
             if (vc)
             {
                 [self hideLoginView];
                 [vc loadUserInformation];
             }
             
         }
         else
         {
             NSLog(@"User with facebook logged in!");
             [self hideLoginView];
             [vc loadUserInformation];
             
         }
     }];
}

-(MenuViewController *)getMenuViewController
{
    MenuViewController *vc = nil;
    if (self.slidingViewController)
    {
        vc = (MenuViewController *)self.slidingViewController.underLeftViewController;
    }
    return vc;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /// data setup
    if ([segue.identifier isEqualToString:kSegueFromHomeToCamera])
    {
        
    }
}

@end
