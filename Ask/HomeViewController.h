//
//  HomeViewController.h
//  Ask
//
//  Created by Dinh Ho on 4/4/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
@interface HomeViewController : UIViewController <MenuViewControllerDelegate>
{
    NSMutableData *imageData;
}

@property (strong, nonatomic) IBOutlet UIView* loginView;

- (IBAction)loginButtonTouchHandler:(id)sender;
-(MenuViewController *)getMenuViewController;

@end
