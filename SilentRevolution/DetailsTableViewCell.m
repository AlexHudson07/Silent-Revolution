//
//  DetailsTableViewCell.m
//  SilentRevolution
//
//  Created by Alex Hudson on 12/11/14.
//  Copyright (c) 2014 Alex Hudson. All rights reserved.
//

#import "DetailsTableViewCell.h"
#import  <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@implementation DetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code

    self.registerButton.layer.cornerRadius = 8;
}

-(void)layoutSubviews
{
    NSString *string = [self.detailEventLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    PFUser *user = [PFUser currentUser];

    if ([user[string] boolValue] == true) {
        self.VIPImageView.image = [UIImage imageNamed:@"Star"];
        self.alreadyResgisterdForEvent = true;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onRegisterButtonPressed:(id)sender {

    if ([PFUser currentUser] || [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {

        [self registerForEvent];
    }

    else{
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Hold On " message:@"Please log on to Facebook to register" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction * LogIn = [UIAlertAction actionWithTitle:@"Log In" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            // Set permissions required from the facebook user account
            NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];

            // Login PFUser using Facebook
            [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {

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

                    [self registerForEvent];

                }
            }];
            [ac dismissViewControllerAnimated:YES completion:nil];
        }];

        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [ac dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [ac addAction:cancel];
        [ac addAction:LogIn];
        
        [self.viewController presentViewController:ac animated:YES completion:nil];
    }
}

- (void) registerForEvent{

    if (self.alreadyResgisterdForEvent) {
        UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"You are already registered for this event" message:nil preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            [ac dismissViewControllerAnimated:YES completion:nil];
        }];

        [ac addAction:ok];

        [self.viewController presentViewController:ac animated:YES completion:^{
            NSLog(@"I got this");
        }];
    }
    else {

    PFQuery * query = [PFQuery queryWithClassName: @"Locations"];

    [query whereKey:@"Event" equalTo:self.detailEventLabel.text];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        //this incremenets the vote on parse by 1

        PFObject *object = [objects objectAtIndex:0];
        int VIPNumber = (int)object[@"VIPNumber"] / 16;

        int VIPLimit = (int) object[@"VIPLimit"] / 16;

        if (VIPNumber < VIPLimit) {
            self.VIPImageView.image = [UIImage imageNamed:@"Star"];

            NSString *string = [self.detailEventLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];

            PFUser *user = [PFUser currentUser];

            user[string] = @YES;

            [user save];

            NSNumber *newVIPNumber = [NSNumber numberWithInt:VIPNumber + 1.0];

            object[@"VIPNumber"] = newVIPNumber;

            [object saveInBackground];

            self.alreadyResgisterdForEvent = true;
        }else{
            UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"Sorry, The VIP limit has been reached" message:nil preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                [ac dismissViewControllerAnimated:YES completion:nil];
            }];

            [ac addAction:ok];

            [self.viewController presentViewController:ac animated:YES completion:^{
                NSLog(@"I got this");
            }];
        }
    }];
    }
}

@end
