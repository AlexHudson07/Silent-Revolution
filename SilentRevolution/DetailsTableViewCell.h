//
//  DetailTableViewCell.h
//  SilentRevolution
//
//  Created by Alex Hudson on 12/7/14.
//  Copyright (c) 2014 Alex Hudson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) IBOutlet UILabel *detailEventLabel;

@property (strong, nonatomic) IBOutlet UILabel *detailTimeLabel;
@property (strong, nonatomic) IBOutlet UITextView *detailDescriptionTextView;

@end
