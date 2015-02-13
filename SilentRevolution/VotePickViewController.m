//
//  VotePickViewController.m
//  SilentRevolution
//
//  Created by Alex Hudson on 1/18/15.
//  Copyright (c) 2015 Alex Hudson. All rights reserved.
//

#import "VotePickViewController.h"

@interface VotePickViewController ()
@property (strong, nonatomic) IBOutlet UIButton *voteMusicButton;
@property (strong, nonatomic) IBOutlet UIButton *voteDJButton;

@end

@implementation VotePickViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     self.voteMusicButton.layer.cornerRadius = 8;
     self.voteDJButton.layer.cornerRadius = 8;

    //Navigationbar cutomization

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    //Back button
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"JuraMedium" size:21]
       }
     forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated{

    self.navigationController.hidesBarsOnSwipe = NO;
    self.navigationItem.title = @"Vote";

    NSDictionary *dictionary =  @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                  NSFontAttributeName:[UIFont fontWithName:@"JuraMedium" size:35]
                                  };

    [self.navigationController.navigationBar setTitleTextAttributes: dictionary];
}

- (IBAction)musicButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"voteMusicSegue" sender:self];
}

- (IBAction)DJButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"voteDJSegue" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
