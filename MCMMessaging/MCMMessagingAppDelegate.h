//
//  MCMMessagingAppDelegate.h
//  MCMMessaging
//
//  Created by Madis Nõmme on 2/18/11.
//  Copyright 2011 Indilo Wireless. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCMessagesController;
@interface MCMMessagingAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

	UITabBarController *_tabBarController;
	NSInteger unreadMessagesCount;
	MCMessagesController *_messagesController;
	UITabBarItem *_messagesTabBarItem;
}

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, assign) NSInteger unreadMessagesCount;
@property (nonatomic, retain) IBOutlet MCMessagesController *messagesController;
@property (nonatomic, retain) IBOutlet UITabBarItem *messagesTabBarItem;

+ (MCMMessagingAppDelegate *)sharedApplication;

@end
