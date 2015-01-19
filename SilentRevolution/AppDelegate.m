//
//  AppDelegate.m
//  SilentRevolution
//
//  Created by Alex Hudson on 12/11/14.
//  Copyright (c) 2014 Alex Hudson. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Parse Key and Secret
    [Parse setApplicationId:@"z9BDO6kif0x6w1mfCAqqGs7MELPeJKeq0WjXu32W"
                  clientKey:@"2Aq88D4GOqINks2rck383wAMC1h2MH8Sqq3RuKAy"];

    //Mikes key and secret
    //[Parse setApplicationId:@"XaCX3SPVRiByPtchR9gkEY3HMQv5je6iXr1dG9Uz"
    //                clientKey:@"2ypIYsF69owrKUTbrmMvgyfyOLAjmda8GRY4P0CH"];

    // Register for Push Notifications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    // ****************************************************************************
    // Your Facebook application id is configured in Info.plist.
    // ****************************************************************************
    [PFFacebookUtils initializeFacebook];

    return YES;
}

//sets off modal allert when receiving notification while in the app
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

// ****************************************************************************
// App switching methods to support Facebook Single Sign-On.
// ****************************************************************************
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    [[PFFacebookUtils session] close];

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

// For action notification 

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [PFPush handlePush:userInfo];
//
//
//    //
//    //Modifiying notification behavior
//    //
//
//    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
//
//    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
//
//    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
//    //App given seconds, not minutes to run in the background
//    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
//
//    //If set to yes message appears red on screen
//    acceptAction.destructive = NO;
//
//    //if set to yes and the phone is locked the user will have to enter passcode when they tap on the action
//    acceptAction.authenticationRequired = NO;
//
//    UIMutableUserNotificationCategory *inviteCatagory = [[UIMutableUserNotificationCategory alloc] init];
//
//    inviteCatagory.identifier = @"INVITE_CATAGORY";
//
//    [inviteCatagory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
//
//    NSSet *categories = [NSSet setWithObjects:inviteCatagory, nil];
//
//    UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:types categories: categories];
//
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//}
//
//-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandle
//{
//    if ([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
//    //    han
//    }
//}

@end
