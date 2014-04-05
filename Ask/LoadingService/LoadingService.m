//
//  LoadingService.m
//  test
//
//  Created by Dinh Ho on 3/25/14.
//  Copyright (c) 2014 Dinh Ho. All rights reserved.
//

#import "LoadingService.h"

@implementation LoadingService
@synthesize loadingView, activityIndicator;
@synthesize searchLabel;
-(id)init
{
    if ((self = [super init]))
    {
        
        loadingView = [[UIView alloc] init];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.alpha = 0.75f;
        loadingView.frame = CGRectMake(100, 250, 120, 90);
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicator.center = CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2);
        [loadingView addSubview:activityIndicator];
        [loadingView bringSubviewToFront:activityIndicator];
        loadingView.layer.cornerRadius = 5;
        searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(loadingView.frame.size.width/2 - 20, (loadingView.frame.size.height/2), 50,50)];
        searchLabel.text = @"Searching...";
        searchLabel.adjustsFontSizeToFitWidth = true;
        searchLabel.textColor = [UIColor whiteColor];
        searchLabel.textAlignment = NSTextAlignmentCenter;
        [loadingView addSubview:searchLabel];
        [loadingView bringSubviewToFront:searchLabel];
        
    }
    return self;
}
+(LoadingService *)sharedLoadingService
{
    static LoadingService *sharedInstance = NULL;
    if (sharedInstance == NULL)
    {
        sharedInstance = [[LoadingService alloc] init];
    }
    return sharedInstance;
}

-(void)startLoading:(UIView *)onView
{
    if (onView)
    {
        [onView addSubview:loadingView];
        [onView bringSubviewToFront:loadingView];
        [activityIndicator startAnimating];
    }

}

-(void)stopLoading:(UIView *)onView
{
    if (onView)
    {
        [activityIndicator stopAnimating];
        [loadingView removeFromSuperview];
    }
}
@end
