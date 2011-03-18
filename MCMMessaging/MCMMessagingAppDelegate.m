//
//  MCMMessagingAppDelegate.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 2/18/11.
//  Copyright 2011 Indilo Wireless. All rights reserved.
//

#import "MCMMessagingAppDelegate.h"
#import "MCNotificationManager.h"
#import "MCMessagesController.h"
static NSString *MCRemoteNotificationRegistrationDeviceToken = @"DeviceTokenRegistered";
@implementation MCMMessagingAppDelegate


@synthesize tabBarController = _tabBarController;
@synthesize window=_window;
@synthesize messagesTabBarItem = _messagesTabBarItem;
@synthesize unreadMessagesCount;
@synthesize messagesController = _messagesController;

+ (MCMMessagingAppDelegate *)sharedApplication
{
	return (MCMMessagingAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if(![userDefaults boolForKey:MCRemoteNotificationRegistrationDeviceToken]) {
		[userDefaults setBool:YES forKey:MCRemoteNotificationRegistrationDeviceToken];
		// TODO: register device token at provider to receive notifications
	}
	
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
									(UIRemoteNotificationTypeAlert |
									 UIRemoteNotificationTypeBadge |
									 UIRemoteNotificationTypeSound)];

	[self.window addSubview:self.tabBarController.view];
	[self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	unreadMessagesCount += 1;
	self.messagesTabBarItem.badgeValue = [NSString stringWithFormat:@"%d", unreadMessagesCount];
	[[MCNotificationManager sharedManager] receivedNotificationWithUserInfo:userInfo];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	[[MCNotificationManager sharedManager] appDidRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
	[[MCNotificationManager sharedManager] registerTokenAtProvider:deviceToken];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	[[MCNotificationManager sharedManager] failedToRegisterForNotificationsWithError:error];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You failed" 
														message:@"App was unable to register for notifications. Check your certificates" 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles: nil];
	[alertView show];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	DLog(@"Did selectItem");
	if (viewController == self.messagesController) {
		DLog(@"And matched messages tab bar item");
		self.unreadMessagesCount = 0;
		self.messagesTabBarItem.badgeValue = nil;
	}
}

- (void)dealloc
{
	[_window release];
	[_tabBarController release];
	[_messagesController release];
	[_messagesTabBarItem release];
    [super dealloc];
}

@end
