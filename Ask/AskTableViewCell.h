//
//  AskTableViewCell.h
//  Ask
//
//  Created by Derrick J Chie on 4/5/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UIButton *pollButton;

- (IBAction)pollButtonPressed:(id)sender;

@end
