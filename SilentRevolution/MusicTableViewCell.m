//
//  MusicTableViewCell.m
//  SilentRevolution
//
//  Created by Alex Hudson on 1/18/15.
//  Copyright (c) 2015 Alex Hudson. All rights reserved.
//

#import "MusicTableViewCell.h"

@implementation MusicTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onVoteButtonPressed:(id)sender {

    int num = (int)self.object[@"Count"];

    NSNumber *number = [NSNumber numberWithInt:((num /16) + 1.0)];
    self.object[@"Count"] = number;

    [self.object saveInBackground];
}

@end
