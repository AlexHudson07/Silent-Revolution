//
//  MusicTableViewCell.h
//  SilentRevolution
//
//  Created by Alex Hudson on 1/18/15.
//  Copyright (c) 2015 Alex Hudson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MusicTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *songName;
@property (strong, nonatomic) IBOutlet UILabel *songLabel;
@property (strong, nonatomic) PFObject *object;

@end
