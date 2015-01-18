//
//  VotePickViewController.m
//  SilentRevolution
//
//  Created by Alex Hudson on 1/18/15.
//  Copyright (c) 2015 Alex Hudson. All rights reserved.
//

#import "VotePickViewController.h"

@interface VotePickViewController ()

@end

@implementation VotePickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
