//
//  MenuViewController.m
//  Ask
//
//  Created by Dinh Ho on 4/4/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import "MenuViewController.h"
#import <Parse/Parse.h>
#import "Globals.h"
#import "FacebookFriend.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize profileImage, nameLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        // Push the next view controller without animation
        // Handle all the log-in view stuff
        [self loadUserInformation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadUserInformation
{
    
    //[self.loginView setHidden:YES];
    
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
                                  //  NSLog(@"friend id %@-friend name %@",friendObject.friendId,friendObject.name);
                                  
                              }
                              
                              
                              
                          }];
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (!error)
         {
             imageData = [[NSMutableData alloc] init];
             [Globals sharedGlobals].userData = (NSDictionary *)result;
             NSString *facebookId = [Globals sharedGlobals].userData[@"id"];
             NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",facebookId]];
             NSURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
             NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
             [connection start];
         }
     }];
    
    
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"connection did was received");
    [imageData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection did finish loading");
    [Globals sharedGlobals].profileImage = [UIImage imageWithData:imageData];
    profileImage.image = [Globals sharedGlobals].profileImage;
    nameLabel.text = [Globals sharedGlobals].userData[@"name"];
}



@end
