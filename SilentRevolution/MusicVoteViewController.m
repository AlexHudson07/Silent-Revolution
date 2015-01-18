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
    self.navigationItem.title = @"Vote For Your Song";

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

    self.musicArray = [NSArray array];

    [self loadNames];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{

    self.navigationController.hidesBarsOnSwipe = YES;
}

- (void)loadNames{

    PFQuery * query = [PFQuery queryWithClassName: @"MusicVote"];

    [query orderByAscending:@"Order"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {


        self.musicArray = objects;

        NSLog(@"");

        [self.tableView reloadData];
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject * tempObject = [self.musicArray objectAtIndex:indexPath.row];

    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.songLabel.text = tempObject[@"Song"];
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
