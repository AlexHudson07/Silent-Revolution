//
//  ThankYouViewController.m
//  SilentRevolution
//
//  Created by Alex Hudson on 1/13/15.
//  Copyright (c) 2015 Alex Hudson. All rights reserved.
//

#import "ThankYouViewController.h"

@interface ThankYouViewController ()
@property (strong, nonatomic) IBOutlet UILabel *thankYouLabel;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@end

@implementation ThankYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];

    self.shareButton.layer.cornerRadius = 8;

    self.thankYouLabel.clipsToBounds = YES;
    self.thankYouLabel.layer.cornerRadius = 8;

}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (IBAction)onBackButtonPressed:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)onShareButtonPressed:(id)sender {

    NSString *string = @"I just voted for my favorite DJ, Drink & Music. We are a few more Votes away from influenceing this event.";

    NSString *url = @"www.thesilentrevolutionmia.com";

    UIImage *myImage = [UIImage imageNamed:@"share"];


    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[string, url, myImage] applicationActivities:nil];

    activityViewController.excludedActivityTypes = @[UIActivityTypeAddToReadingList,
                                                     UIActivityTypeAirDrop,
                                                     UIActivityTypeCopyToPasteboard,
                                                     UIActivityTypePostToTencentWeibo,
                                                     UIActivityTypePostToFlickr,
                                                     UIActivityTypeSaveToCameraRoll,
                                                     UIActivityTypeAssignToContact,
                                                     UIActivityTypePrint,
                                                     UIActivityTypeMail,
                                                     UIActivityTypeMessage];

    [self presentViewController:activityViewController animated:YES completion:nil];
}


@end
