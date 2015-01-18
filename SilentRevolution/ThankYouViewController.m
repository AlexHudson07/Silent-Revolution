//
//  ThankYouViewController.m
//  SilentRevolution
//
//  Created by Alex Hudson on 1/13/15.
//  Copyright (c) 2015 Alex Hudson. All rights reserved.
//

#import "ThankYouViewController.h"

@interface ThankYouViewController ()

@end

@implementation ThankYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];

}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (IBAction)onBackButtonPressed:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)onShareButtonPressed:(id)sender {

    NSString *string = @"I just voted for the Silent Revolution";

    NSString *url = @"www.feelingutsy.com";

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
