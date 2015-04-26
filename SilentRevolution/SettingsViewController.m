//
//  SettingsViewController.m
//  SilentRevolution
//
//  Created by Alex Hudson on 4/26/15.
//  Copyright (c) 2015 Alex Hudson. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *logOffButton;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.logOffButton.layer.cornerRadius = 8;

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"JuraMedium" size:21]
       }
     forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated{

    self.navigationController.hidesBarsOnSwipe = NO;
    self.navigationItem.title = @"Settings";

    NSDictionary *dictionary =  @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                  NSFontAttributeName:[UIFont fontWithName:@"JuraMedium" size:35]
                                  };

    [self.navigationController.navigationBar setTitleTextAttributes: dictionary];
}
- (IBAction)onLogOffButtonPressed:(id)sender {

    [PFUser logOut];
}

@end
