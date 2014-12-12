//
//  DetailsViewController.m
//  SilentRevolution
//
//  Created by Alex Hudson on 12/6/14.
//  Copyright (c) 2014 Alex Hudson. All rights reserved.
//

#import "DetailsViewController.h"
#import <Parse/Parse.h>
#import "DetailsTableViewCell.h"

@interface DetailsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    self.navigationController.tabBarItem.title = @"Details";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject * tempObject = [self.infoArray objectAtIndex:indexPath.row];

    DetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.detailEventLabel.text = tempObject[@"Event"];
    cell.detailTimeLabel.text = tempObject[@"Time"];
    cell.detailDescriptionTextView.text = tempObject[@"Description"];

    [tempObject[@"Photo"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

        cell.detailImageView.layer.cornerRadius=8;
        cell.detailImageView.layer.borderWidth=2.0;
        cell.detailImageView.layer.masksToBounds = YES;
        cell.detailImageView.layer.borderColor = [[UIColor colorWithRed:123.f/255 green:174.f/255 blue:45.f/2555 alpha:1] CGColor];
        cell.detailImageView.image = [UIImage imageWithData:data];
    }];

    return cell;
}

@end
