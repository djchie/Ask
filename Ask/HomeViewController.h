//
//  HomeViewController.h
//  Ask
//
//  Created by Dinh Ho on 4/4/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView* loginView;

- (IBAction)loginButtonTouchHandler:(id)sender;

@end
