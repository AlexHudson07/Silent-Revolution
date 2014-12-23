//
//  AppDelegate.m
//  SilentRevolution
//
//  Created by Alex Hudson on 12/11/14.
//  Copyright (c) 2014 Alex Hudson. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Parse Key and Secret
    [Parse setApplicationId:@"z9BDO6kif0x6w1mfCAqqGs7MELPeJKeq0WjXu32W"
                  clientKey:@"2Aq88D4GOqINks2rck383wAMC1h2MH8Sqq3RuKAy"];

    // Register for Push Notifications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
