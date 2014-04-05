//
//  HomeViewController.h
//  Ask
//
//  Created by Dinh Ho on 4/4/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
@interface HomeViewController : UIViewController
{
}

@property (strong, nonatomic) IBOutlet UIView* loginView;
@property (weak, nonatomic) IBOutlet UITableView *myQuestionsTableView;
@property (weak, nonatomic) IBOutlet UITableView *friendsQuestionTableView;

@property (weak, nonatomic) IBOutlet UIButton *askButton;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tableViewSegmentedControl;

- (IBAction)loginButtonTouchHandler:(id)sender;
- (IBAction)yesButtonPressed:(id)sender;
- (IBAction)noButtonPressed:(id)sender;
- (IBAction)tableViewSegmentedControlPressed:(id)sender;


-(MenuViewController *)getMenuViewController;

@end
