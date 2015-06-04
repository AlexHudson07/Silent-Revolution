//
//  MusicVoteViewController.m
//  SilentRevolution
//
//  Created by Alex Hudson on 1/18/15.
//  Copyright (c) 2015 Alex Hudson. All rights reserved.
//

#import "MusicVoteViewController.h"
#import <Parse/Parse.h>
#import "ThankYouViewController.h"
#import "MusicTableViewCell.h"


@interface MusicVoteViewController ()

@property (strong, nonatomic) NSArray *musicArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MusicVoteViewController

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

    self.musicArray = [NSArray array];
}

-(void)viewWillAppear:(BOOL)animated {

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

        NSDate *firstDate = user[@"musicVoteTime"];

        if (!firstDate) {
            firstDate = [NSDate date];
            user[@"musicVoteTime"] = firstDate;
            [user saveInBackground];
        }

        if ([secondDate timeIntervalSinceDate:firstDate] > 120) {

            [self loadNames];
        }
        else {

            float voteTime = 120 - [secondDate timeIntervalSinceDate:firstDate];

            NSString *string = [NSString stringWithFormat:@"You can vote again in %.0f seconds", voteTime];

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

    PFQuery * query = [PFQuery queryWithClassName: @"MusicVote"];

    [query orderByAscending:@"Order"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        self.musicArray = objects;

        [self.tableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject * tempObject = [self.musicArray objectAtIndex:indexPath.row];

    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.songLabel.text = tempObject[@"Song"];
    cell.artistLabel.text = tempObject[@"Artist"];
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
