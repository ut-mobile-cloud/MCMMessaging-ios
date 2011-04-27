//
//  MCAsynchronousTests.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 4/25/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCAsynchronousTests.h"


@implementation MCAsynchronousTests

- (NSString *)description
{
	return @"Invoke services form MCM using asynchronous communication";
}

- (NSString *)name
{
	return @"ASync";
}

/**
 *	@brief Moves remote data using synchronous communication with MCM and measures times.
 *
 *	Will move data between clouds (or other remote storage resources) and measure following time parameters:
 *		1. total time taken - measured in phone
 *		2. time taken in MCM to complete the task - requested from MCM
 *		3. time for delivering Push Notification - calculated as follows:
 *			1) requests empty task to be performed (time taken == 0)
 *			2) immediately when server responds, marks start time (associated w/ taskID)
 *			3) when push notification arrives, stops timer (associated w/ taskID, difference is the duration)
 */
- (NSDictionary *)executeTest
{
	
	return nil;
}
- (void)main
{
	DLog(@"I'm running i'm running...");
}

@end
