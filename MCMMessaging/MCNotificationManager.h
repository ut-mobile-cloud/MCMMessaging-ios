//
//  MCNotificationManager.h
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/1/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *MCReceivedNotificationIdentifier;
extern NSString *MCReceivedResultsNotification;

@interface MCNotificationManager : NSObject {
	NSArray *notifications;
	NSMutableArray *results;
}

@property (nonatomic, readonly) NSArray *messages;

+ (MCNotificationManager *)sharedManager;

- (NSString *)deviceID;
- (void)appDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token;
- (void)registerTokenAtProvider:(NSData *)token;
- (void)receivedNotificationWithUserInfo: (NSDictionary *)userInfo;
- (void)failedToRegisterForNotificationsWithError:(NSError *)error;

@end
