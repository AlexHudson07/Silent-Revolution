//
//  EventViewController.m
//  SilentRevolution
//
//  Created by Alex Hudson on 1/18/15.
//  Copyright (c) 2015 Alex Hudson. All rights reserved.
//

#import "EventViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>


@interface EventViewController ()
@property (strong, nonatomic) IBOutlet UIButton *facebookLoginButton;

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if ([PFUser currentUser] || [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {

        [self.facebookLoginButton setTitle:@"signed in" forState:UIControlStateNormal];

    }
}

-(void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBarHidden = NO;
    self.navigationController.hidesBarsOnSwipe = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonTouchHandler:(id)sender  {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];

    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
    //    [_activityIndicator stopAnimating]; // Hide loading indicator

        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
            } else {
                NSLog(@"User with facebook logged in!");
            }
       //     [self _presentUserDetailsViewControllerAnimated:YES];
        }
    }];

   // [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}

@end
