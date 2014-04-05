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
#import "MakeQuestionViewController.h"

#define kSegueFromCameraToMakeQuestion @"cameraToMakeQuestion"

@interface HomeViewController ()

@end

@implementation HomeViewController



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        // Push the next view controller without animation
        // Handle all the log-in view stuff
       // [self loadUserInformation];

        [self loadHomeView];
    }
    else
    {
        [self.view bringSubviewToFront:self.loginView];
        self.navigationController.navigationBar.hidden = true;
        
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}
- (void)loadComplete
{
//    [[LoadingService sharedLoadingService] stopLoading:self.view];
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)loadHomeView
{
    self.loginView.hidden = true;
    if ([Globals sharedGlobals].userData)
    {
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }

    [self.tableViewSegmentedControl setSelectedSegmentIndex:0];
    [self tableViewSegmentedControlPressed:self.tableViewSegmentedControl];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadUserInformation
{
    // Loads all the questions/answers into table
    [FBRequestConnection startWithGraphPath:@"/me/friends"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ){
                              NSDictionary *d = (NSDictionary *)result;
                              NSDictionary *data = [d objectForKey:@"data"];
                              for (id s in data)
                              {
                                  FacebookFriend *friendObject = [[FacebookFriend alloc]init];
                                  friendObject.friendId = [s objectForKey:@"id"];
                                  friendObject.name = [s objectForKey:@"name"];
                                  [[Globals sharedGlobals].friendsArray addObject:friendObject];
                                  NSLog(@"friend id %@-friend name %@",friendObject.friendId,friendObject.name);
                                  
                              }
        
                            
        
                          }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    [self performSegueWithIdentifier:kSegueFromCameraToMakeQuestion sender:self];
    //User took picture and pressed "Use Photo" button
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        //NSData send to next view through segue
        self.takenPicture = UIImagePNGRepresentation(editedImage);
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self performSegueWithIdentifier:kSegueFromCameraToMakeQuestion sender:self];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //User pressed cancel -> should move to next view as no picture option
    [self dismissViewControllerAnimated:NO completion:nil];
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
                 [self loadHomeView];
                 [vc loadUserInformation];
             }
             
         }
         else
         {
             NSLog(@"User with facebook logged in!");
             [self loadHomeView];
             [vc loadUserInformation];
             
         }
     }];
}

- (IBAction)askButtonPressed:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)yesButtonPressed:(id)sender
{
    
}

- (IBAction)noButtonPressed:(id)sender
{
    
}

- (IBAction)tableViewSegmentedControlPressed:(id)sender
{
    if ([sender selectedSegmentIndex] == 0)
    {
        [self.myQuestionsTableView setHidden:NO];
        [self.friendsQuestionTableView setHidden:YES];
        [self.askButton setHidden:NO];
        [self.yesButton setHidden:YES];
        [self.noButton setHidden:YES];
    }
    else if ([sender selectedSegmentIndex] == 1)
    {
        [self.myQuestionsTableView setHidden:YES];
        [self.friendsQuestionTableView setHidden:NO];
        [self.askButton setHidden:YES];
        [self.yesButton setHidden:NO];
        [self.noButton setHidden:NO];
    }
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
- (IBAction)listButtonHandler:(id)sender
{
    if (self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight)
    {
        [self.slidingViewController resetTopViewAnimated:true];
        
    }
    else if (self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionCentered)
    {
        [self.slidingViewController anchorTopViewToRightAnimated:true];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /// data setup
    if ([segue.identifier isEqualToString:kSegueFromCameraToMakeQuestion])
    {
        MakeQuestionViewController* makeQuestionVC = [segue destinationViewController];
        [makeQuestionVC setTakenPicture:self.takenPicture];
    }
}

@end
