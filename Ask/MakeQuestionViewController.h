//
//  MakeQuestionViewController.h
//  Ask
//
//  Created by Derrick J Chie on 4/5/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakeQuestionViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) NSData* takenPicture;

@property (weak, nonatomic) IBOutlet UIImageView *questionImageView;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;

- (IBAction)nextButtonPressed:(id)sender;

@end
