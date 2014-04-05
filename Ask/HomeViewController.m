//
//  HomeViewController.m
//  Ask
//
//  Created by Dinh Ho on 4/4/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import "HomeViewController.h"
#include "UIViewController+ECSlidingViewController.h"


#define kSegueFromHomeToCamera @"homeToCamera"

@interface HomeViewController ()

@end

@implementation HomeViewController



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /// data setup
    if ([segue.identifier isEqualToString:kSegueFromHomeToCamera])
    {
        
    }
}
@end
