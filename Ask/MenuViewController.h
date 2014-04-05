//
//  MenuViewController.h
//  Ask
//
//  Created by Dinh Ho on 4/4/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol MenuViewControllerDelegate <NSObject>
//- (void)startLoading;
//- (void)loadComplete;
//@end

@interface MenuViewController : UIViewController <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

{
    NSMutableData *imageData;
}

- (void)loadUserInformation;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (nonatomic, weak) id <MenuViewControllerDelegate> delegate;


@end
