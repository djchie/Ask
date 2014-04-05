//
//  FBLoginViewController.m
//  Ask
//
//  Created by Dinh Ho on 4/4/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import "FBLoginViewController.h"
#import <Parse/Parse.h>
#import "HomeViewController.h"
#define kSegueToSlidingView @"loginToSlide"

@interface FBLoginViewController ()

@end

@implementation FBLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}



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
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error)
    {
        if (!user)
        {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self performSegueWithIdentifier:kSegueToSlidingView sender:self];

        }
        else
        {
            NSLog(@"User with facebook logged in!");
            [self performSegueWithIdentifier:kSegueToSlidingView sender:self];
     
        }
    }];
}

@end
