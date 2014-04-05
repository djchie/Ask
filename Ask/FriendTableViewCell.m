//
//  FriendTableViewCell.m
//  Ask
//
//  Created by David Chung on 4/5/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell
@synthesize selectImage;
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
