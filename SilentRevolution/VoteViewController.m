//
//  VoteViewController.m
//  SilentRevolution
//
//  Created by Alex Hudson on 1/13/15.
//  Copyright (c) 2015 Alex Hudson. All rights reserved.
//

#import "VoteViewController.h"
#import <Parse/Parse.h>

@interface VoteViewController ()
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;
//@property (strong, nonatomic) NSMutableArray *voteCount;

@end

@implementation VoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"Event Name";

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

    self.button1.layer.cornerRadius = 8;
    self.button2.layer.cornerRadius = 8;
    self.button3.layer.cornerRadius = 8;

    [self loadNames];
}

-(void)loadNames{

    PFQuery * query = [PFQuery queryWithClassName: @"Vote"];

    [query orderByAscending:@"Order"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        PFObject *one = [objects objectAtIndex:0];
        [self.button1 setTitle:one[@"Name"] forState:UIControlStateNormal];;

        PFObject *two = [objects objectAtIndex:1];
        [self.button2 setTitle:two[@"Name"] forState:UIControlStateNormal];;

        PFObject *three = [objects objectAtIndex:2];
        [self.button3 setTitle:three[@"Name"] forState:UIControlStateNormal];
    }];
}
- (IBAction)oneButtonOnePressed:(id)sender {

    [self updateCounter:0];
    [self disableButtons];
}

- (IBAction)onButtonTwoPressed:(id)sender {

    [self updateCounter:1];
    [self disableButtons];
}

- (IBAction)onButtonThreePressed:(id)sender {

    [self updateCounter:2];
    [self disableButtons];
}

- (void) disableButtons {

    self.button1.enabled = NO;
    self.button2.enabled = NO;
    self.button3.enabled = NO;
}

- (void) updateCounter:(int) namePosition {
    __block int i = 0;
    __block NSMutableArray *voteCount = [NSMutableArray  array];

    PFQuery * query = [PFQuery queryWithClassName: @"Vote"];

    [query orderByAscending:@"Order"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        for (PFObject *object in objects) {

            [voteCount addObject:object[@"Count"]];

            if (i == namePosition) {

                int num = (int)[voteCount objectAtIndex:namePosition];

                NSNumber *number = [NSNumber numberWithInt:((num /16) + 1.0)];
                object[@"Count"] = number;

                [object saveInBackground];
            }
            i++;
        }
        voteCount = nil;
    }];
}

@end