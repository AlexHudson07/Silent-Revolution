//
//  VoteViewController.m
//  SilentRevolution
//
//  Created by Alex Hudson on 1/13/15.
//  Copyright (c) 2015 Alex Hudson. All rights reserved.
//

#import "DJVoteViewController.h"
#import <Parse/Parse.h>
#import "ThankYouViewController.h"
#import "DJTableViewCell.h"


@interface DJVoteViewController ()
@property (strong, nonatomic) NSArray *DJArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DJVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"Vote For The Best";


    NSDictionary *dictionary =  @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                  NSFontAttributeName:[UIFont fontWithName:@"JuraMedium" size:35]
                                  };

    [self.navigationController.navigationBar setTitleTextAttributes: dictionary];

    //Back button
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"JuraMedium" size:21]
       }
     forState:UIControlStateNormal];

    self.DJArray = [NSArray array];

    [self loadNames];

}

- (void)viewWillAppear:(BOOL)animated
{
   // [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.hidesBarsOnSwipe = YES;
}

- (void)loadNames{

    PFQuery * query = [PFQuery queryWithClassName: @"Vote"];

    [query orderByAscending:@"Order"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        self.DJArray = objects;

        [self.tableView reloadData];
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.DJArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject * tempObject = [self.DJArray objectAtIndex:indexPath.row];

    DJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.songLabel.text = tempObject[@"Name"];
    cell.object = tempObject;

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    ThankYouViewController *VC = [segue destinationViewController];
    [VC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
