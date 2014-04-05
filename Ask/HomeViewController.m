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
#import "Constants.h"
#import "LoadingService.h"
#import "MakeQuestionViewController.h"
#import "AskTableViewCell.h"

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

- (void)loadHomeView
{
    self.navigationController.navigationBar.hidden = false;
    
    self.loginView.hidden = true;
    if ([Globals sharedGlobals].userData)
    {
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
    
    UINib *nib = [UINib nibWithNibName:@"AskTableViewCell" bundle:nil];
    [[self friendsQuestionTableView] registerNib:nib forCellReuseIdentifier:@"AskTableViewCell"];
    [[self myQuestionsTableView] registerNib:nib forCellReuseIdentifier:@"AskTableViewCell"];
    
    [self.myQuestionsTableView setDelegate:self];
    [self.myQuestionsTableView setDataSource:self];
    [self.friendsQuestionTableView setDelegate:self];
    [self.friendsQuestionTableView setDataSource:self];

    [self.tableViewSegmentedControl setSelectedSegmentIndex:0];
    [self tableViewSegmentedControlPressed:self.tableViewSegmentedControl];
    
    [self fetchMyQuestions];
    [self fetchFriendsQuestions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)fetchNoResponseQuestion
{
    PFQuery *query = [PFQuery queryWithClassName:kQuestionClassName];
    [query whereKey:kImageName equalTo:[NSNumber numberWithInt:1]];
    [query getOb:(PFObject *object, NSError *error)
    {
        if (!error)
        {
            PFFile *file = [object objectForKey:@"image"];
            // file has not been downloaded yet, we just have a handle on this file
            
            // Tell the PFImageView about your file
            imageView.file = file;
            
            // Now tell PFImageView to download the file asynchronously
            [imageView loadInBackground];
        }
    }];
}

- (void)fetchMyQuestions
{
    PFQuery* myQuestionsQuery = [PFQuery queryWithClassName:@"Question"];
    [myQuestionsQuery whereKey:kCreatedBy equalTo:[[PFUser currentUser] username]];
    [myQuestionsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            self.myQuestions = objects;
            [self.myQuestionsTableView reloadData];
        }
        else
        {
            NSLog(@"%@", error.description);
        }
    }];
}

- (void)fetchFriendsQuestions
{
    PFQuery* friendsQuestionsQuery = [PFQuery queryWithClassName:@"Question"];
    [friendsQuestionsQuery whereKey:kRecipient equalTo:([[PFUser currentUser] username])];
    [friendsQuestionsQuery whereKey:kAnswered equalTo:[NSNumber numberWithBool:false]];
    [friendsQuestionsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            self.friendsQuestions = objects;
            [self.friendsQuestionTableView reloadData];
        }
        else
        {
            NSLog(@"%@", error.description);
        }
    }];
}

#pragma UITableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    
    if (tableView == self.myQuestionsTableView)
    {
        count = self.myQuestions.count;
    }
    else if (tableView == self.friendsQuestionTableView)
    {
        count = self.friendsQuestions.count;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"AskTableViewCell";
    AskTableViewCell* cell = (AskTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[AskTableViewCell alloc] init];
    }
    
    if (tableView == self.myQuestionsTableView)
    {
        PFObject* myQuestion = [[self myQuestions] objectAtIndex:[indexPath row]];
        
        cell.questionLabel.text = [myQuestion objectForKey:kQuestionText];
        
        // Images to do
        
        
        // Handle cell's response image
        
        if ([[myQuestion objectForKey:kType] intValue] == 1)
        {
            [cell.pollButton setHidden:NO];
            [cell.statusImageView setHidden:YES];
        }
        else
        {
            if ([[myQuestion objectForKey:kResponse] intValue] == 0)
            {
                [cell.statusImageView setImage:[UIImage imageNamed:@"no.png"]];
            }
            else if ([[myQuestion objectForKey:kResponse] intValue] == 1)
            {
                [cell.statusImageView setImage:[UIImage imageNamed:@"yes.png"]];
            }
        }
    }
    else if (tableView == self.friendsQuestionTableView)
    {
        PFObject* friendsQuestion = [[self friendsQuestions] objectAtIndex:[indexPath row]];
        
        cell.questionLabel.text = [friendsQuestion objectForKey:kQuestionText];
        
        // Images to do

        [cell.pollButton setHidden:YES];
        [cell.statusImageView setHidden:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.myQuestionsTableView)
    {
        PFObject* myQuestion = [[self myQuestions] objectAtIndex:[indexPath row]];
        
        if ([[myQuestion objectForKey:kType] intValue] == 1)
        {
//            [self performSegueWithIdentifier:<#(NSString *)#> sender:<#(id)#>]
        }
    }
    else if (tableView == self.friendsQuestionTableView)
    {
        PFObject* friendsQuestion = [[self friendsQuestions] objectAtIndex:[indexPath row]];
        self.selectedFriendsQuestion = friendsQuestion;
    }
}

#pragma IBAction methods

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
#if TARGET_IPHONE_SIMULATOR
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera is not available in simulator" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
#else
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
#endif
    
}

- (IBAction)yesButtonPressed:(id)sender
{
    if (self.selectedFriendsQuestion)
    {
        PFObject* yesAnswer = [PFObject objectWithClassName:@"Answer"];
        
        [yesAnswer setObject:[NSNumber numberWithInt:1] forKey:kResponse];
        [yesAnswer setObject:[[PFUser currentUser] username] forKey:kCreatedBy];
        [yesAnswer setObject:[self.selectedFriendsQuestion objectId] forKey:kQuestionId];
        
        [yesAnswer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error)
            {
                NSLog(@"Your friend's question has been answered!");
            }
            else
            {
                NSLog(@"%@", error.description);
            }
        }];
        
        // Need to mark question as answered
        
        PFQuery* updateQuestionQuery = [PFQuery queryWithClassName:kQuestionClassName];
        
        [updateQuestionQuery getObjectInBackgroundWithId:[self.selectedFriendsQuestion objectId] block:^(PFObject *object, NSError *error)
         {
             [object setObject:[NSNumber numberWithBool:YES] forKey:kAnswered];
             [object saveInBackground];
             
             [self fetchFriendsQuestions];
         }];
    }
}

- (IBAction)noButtonPressed:(id)sender
{
    if (self.selectedFriendsQuestion)
    {
        PFObject* noAnswer = [PFObject objectWithClassName:@"Answer"];
        
        [noAnswer setObject:[NSNumber numberWithInt:0] forKey:kResponse];
        [noAnswer setObject:[[PFUser currentUser] username] forKey:kCreatedBy];
        [noAnswer setObject:[self.selectedFriendsQuestion objectId] forKey:kQuestionId];
        
        [noAnswer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error)
            {
                NSLog(@"Your friend's question has been answered!");
            }
        }];
        
        // Need to mark question as answered
        
        PFQuery* updateQuestionQuery = [PFQuery queryWithClassName:kQuestionClassName];
        
        [updateQuestionQuery getObjectInBackgroundWithId:[self.selectedFriendsQuestion objectId] block:^(PFObject *object, NSError *error)
         {
             [object setObject:[NSNumber numberWithBool:YES] forKey:kAnswered];
             [object saveInBackground];
             
             [self fetchFriendsQuestions];
         }];
    }
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

#pragma Segue methods

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
