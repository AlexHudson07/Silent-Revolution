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
    self.navigationItem.title = @"Vote For Your Fav";


    NSDictionary *dictionary =  @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                  NSFontAttributeName:[UIFont fontWithName:@"JuraMedium" size:25]
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
}

- (void)viewWillAppear:(BOOL)animated {
   // [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.hidesBarsOnSwipe = YES;

    [self checkingIfCanVote];
}

- (void)checkingIfCanVote {

    __block PFUser *user = nil;

    __block NSDate *secondDate = [NSDate date];

    PFQuery * query = [PFUser query];

    [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        user = [objects objectAtIndex:0];

        NSDate *firstDate = user[@"DJVoteTime"];

        if (!firstDate) {
            firstDate = [NSDate date];
            user[@"DJVoteTime"] = firstDate;
            [user saveInBackground];
        }

        if ([secondDate timeIntervalSinceDate:firstDate] > 1800.0) {

            [self loadNames];
        }
        else{

            float voteTime = (1800.0 - [secondDate timeIntervalSinceDate:firstDate]) / 60;

            NSString *string = [NSString stringWithFormat:@"You can vote again in %.0f minutes", voteTime];

            UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"NOT YET" message:string preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                [ac dismissViewControllerAnimated:YES completion:nil];  } ];

            [ac addAction:ok];
            
            [self presentViewController:ac animated:YES completion:^{
            }];
            
        }
    }];
}

- (void)loadNames {

    PFQuery * query = [PFQuery queryWithClassName: @"Vote"];

    [query orderByAscending:@"Order"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        self.DJArray = objects;

        [self.tableView reloadData];
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.DJArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PFObject * tempObject = [self.DJArray objectAtIndex:indexPath.row];

    DJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.songLabel.text = tempObject[@"Name"];
    cell.object = tempObject;

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    ThankYouViewController *VC = [segue destinationViewController];
    [VC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

@end
