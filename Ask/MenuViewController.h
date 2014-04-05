//
//  MenuViewController.h
//  Ask
//
//  Created by Dinh Ho on 4/4/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

{
    NSMutableData *imageData;
}

- (void)loadUserInformation;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end
