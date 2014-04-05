//
//  LoadingService.h
//  test
//
//  Created by Dinh Ho on 3/25/14.
//  Copyright (c) 2014 Dinh Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadingService : NSObject

@property(nonatomic, strong)UIView *loadingView;
@property(nonatomic, strong)UIActivityIndicatorView* activityIndicator;
@property(nonatomic, strong)UILabel *searchLabel;
@property(nonatomic, assign)CGFloat cornerRadius;

-(void)startLoading:(UIView *)onView;
-(void)stopLoading:(UIView *)onView;
+(LoadingService *)sharedLoadingService;

@end
