//
//  FBLoginViewController.h
//  Ask
//
//  Created by Dinh Ho on 4/4/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <FacebookSDK/FacebookSDK.h>

@interface FBLoginViewController : UIViewController <FBLoginViewDelegate>

- (IBAction)loginButtonTouchHandler:(id)sender;


@end
