//
//  MCNotificationManager.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/1/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCNotificationManager.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "NSData+Additions.h"
#import "JSON.h"
#import "MCAppSettings.h"
#import <QuartzCore/QuartzCore.h>
#import "MCTaskTimes.h"

NSString *MCReceivedNotificationIdentifier = @"MCReceivedNotificationIdentifier";
NSString *MCReceivedResultsNotification = @"MCReceivedResultsNotification";
NSString *MCAsyncTestResultNotification = @"MCAsyncTestResultNotification";
//static NSString *MCProviderRegistrationURLMask = @"http://localhost:8084/RegisterForNotifications?deviceID=%@&deviceType=iphone";
//static NSString *MCUserDefaultsDeviceTokenKey = @"MCUserDefaultsDeviceTokenKey";


@implementation MCNotificationManager

+ (MCNotificationManager *)sharedManager
{
	static MCNotificationManager *instance = nil;
	if(instance == nil) {
		instance = [[MCNotificationManager alloc] init];
	}
	return instance;
}

- (id)init
{
	self = [super init];
	if(self) {
		results = [[NSMutableArray arrayWithCapacity:0] retain];
	}
	return self;
}
@dynamic messages;
- (NSArray *)messages
{
	return results;
}

-(NSString *)deviceID
{
//	static NSString *deviceID = nil;
//	if (deviceID == nil) {
//		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//		deviceID = [[userDefaults stringForKey:MCUserDefaultsDeviceTokenKey] retain];
//	}
//	return deviceID;
	// TODO: save this key in user defaults after first registration (because
	// it won't change. Then return it here.
	// This value must not be hard coded because it will be different on each device
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
}
- (void)appDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token
{
	const char* data = [token bytes];
	NSMutableString *tokenString = [NSMutableString string];
	for (int i = 0; i < [token length]; i++) {
		[tokenString appendFormat:@"%02.2hhX", data[i]];
	}
	[[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:@"deviceToken"];
}

- (void)registerTokenAtProvider:(NSData *)token;
{
	/* TODO:
		1) The application calls the registerForRemoteNotificationTypes: method of UIApplication.
		2) It implements the application:didRegisterForRemoteNotificationsWithDeviceToken: method of UIApplicationDelegate to receive the device token.
		3) It passes the device token to its provider as a non-object, binary value.
	 @see http://developer.apple.com/library/ios/#documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/IPhoneOSClientImp/IPhoneOSClientImp.html
	 */
	// TODO: until registration is implemented at server, nothing this method should remain empty
	/*
	NSURL *registrationURL = [[MCAppSettings sharedSettings] urlWithServletName:@"RegisterForNotifications"];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:registrationURL];
	[request addPostValue:[self deviceID] forKey:@"deviceID"];
	request.delegate = self;
	[request startSynchronous];
	 */
}

- (void)notifyAsyncTestResult:(NSString *)testID
{
	[[NSNotificationCenter defaultCenter] postNotificationName:MCAsyncTestResultNotification object:nil userInfo:[NSDictionary dictionaryWithObject:testID forKey:@"testID"]];
}
/**
 	Will be called when server finishes requested job
 	Response payload will contain NSDictionary with following form:
 	{
 		aps =     {
 			alert = "Vastus : 15";
 			badge = 1;
 			sound = default;
 		};
 This method should then:
	1) request the results that it does not already have (or all of them)
	2) parse & store this respnse locally
	3) send out local (in-app) notification so those who need can display update info
 */
- (void)receivedNotificationWithUserInfo: (NSDictionary *)userInfo
{
	NSString *taskID = [userInfo objectForKey:@"taskID"];
	NSString *resultType = [userInfo objectForKey:@"resultType"];
	if ([resultType isEqual:@"AsyncTestResult"]) {
		[self notifyAsyncTestResult:[userInfo objectForKey:@"testID"]];
	} else {
		DLog(@"Received a notification : taskID == %@", taskID);
		NSURL *resultsURL = [[MCAppSettings sharedSettings] urlWithServletName:@"RequestResults"];
		ASIFormDataRequest *resultsRequest = [ASIFormDataRequest requestWithURL:resultsURL];
		[resultsRequest addPostValue:taskID forKey:@"taskID"];
		
		float startResultsRequest = CACurrentMediaTime();
		[resultsRequest startSynchronous];
		float requestDuration = CACurrentMediaTime() - startResultsRequest;
		
		MCTaskTimes *durationForTask = [[MCTaskTimes alloc] initWithTaskID:taskID];
		durationForTask.results = requestDuration;
		
		[MCTaskTimes sendTimesToServer:durationForTask];
		NSError *error = [resultsRequest error];
		NSString *newResult = nil;
		if(!error) {
			newResult = [resultsRequest responseString];
			[results addObject:newResult];
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:newResult forKey:@"newResult"];
			[[NSNotificationCenter defaultCenter] postNotificationName:MCReceivedResultsNotification object:self userInfo:userInfo];
		} else {
			DLog(@"error : %@", error);
		}
	}
	
}

- (void)failedToRegisterForNotificationsWithError:(NSError *)error
{
	DLog(@"Failed to register for notifications at Apple");
}

#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
	DLog(@"Request finished, %@", [request responseStatusMessage]);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	DLog(@"Failed to register at provider");
}

- (void)dealloc
{
	[results release];
	[super dealloc];
}
@end
