//
//  DJTableViewCell.m
//  SilentRevolution
//
//  Created by Alex Hudson on 1/18/15.
//  Copyright (c) 2015 Alex Hudson. All rights reserved.
//

#import "DJTableViewCell.h"

@implementation DJTableViewCell

- (void)awakeFromNib {

    self.voteButton.layer.cornerRadius = 8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
}

- (IBAction)onVoteButtonPressed:(id)sender {

    //this incremenets the vote on parse by 1
    int num = (int)self.object[@"Count"];

    NSNumber *number = [NSNumber numberWithInt:((num /16) + 1.0)];
    self.object[@"Count"] = number;

    [self.object saveInBackground];

    //this disables the user from voting once they vote for a DJ
    PFUser *user = [PFUser currentUser];
     user[@"DJVoteTime"] = [NSDate date];

    [user save];
}

@end
