//
//  MCAsynchronousTests.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 4/25/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCAsynchronousTests.h"
#import "MCTimeSynchronizer.h"
#import "MCAsyncTestTimes.h"
#import "ASIFormDataRequest.h"
#import "MCAppSettings.h"
#import "NSData+Additions.h"
#import "JSON.h"
#import "MCNotificationManager.h"

static NSString *MCAsynchronousTestsServletName = @"AsyncTestsServlet";
static int TIMES_TO_RUN = 2;
static int MCDataSize1MB = 1048576;
@implementation MCAsynchronousTests

@synthesize testTimes;

- (NSString *)description
{
	return @"Invoke services form MCM using asynchronous communication";
}

- (NSString *)name
{
	return @"ASync";
}

/**
 *	TODO: change(update) the object that is passed into this method. You should not create a new object. I think this way is better. Madis.
 */
- (void)syncTimesWithServerForTaskID:(NSString *)testID
{
	MCAsyncTestTimes *times = [testTimes objectForKey:testID];
	if (times == nil) {
		return;
	}
	
	NSURL *mcmAsyncTimesServletURL = [[MCAppSettings sharedSettings] urlWithServletName:@"RequestTestTimesServlet"];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:mcmAsyncTimesServletURL];
	[request addPostValue:@"AsyncTests" forKey:@"testType"];
	[request addPostValue:times.testID forKey:@"testID"];
	[request addPostValue:[times JSONRepresentation] forKey:@"clientTimes"];
	[request startSynchronous];
	MCAsyncTestTimes *newTimes = [[MCAsyncTestTimes alloc] init];
	NSError *error = [request error];
	if (!error && [request responseStatusCode] == 200) {
		NSString *responseJson = [request responseString];
		SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
		id jsonObject = [jsonParser objectWithString:responseJson];
		[newTimes setValuesForKeysWithDictionary:jsonObject];
	}
	if ([newTimes.testID isEqual:times.testID]) {
		// Only replace if server gives us back info for the same test
		[self.testTimes removeObjectForKey:times];
		[self.testTimes setValue:newTimes forKey:newTimes.testID];
	} else {
		DLog(@"Unable to sync times with server : server gave back times with wrong testID");
		DLog(@"oldTimes.testID==%@ vs. newTimes.testID==%@", times.testID, newTimes.testID);
	}
	DLog(@"New times : %@", newTimes);
	[newTimes release];
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
- (MCAsyncTestTimes *)executeTest
{
	MCAsyncTestTimes *times = [[MCAsyncTestTimes alloc] init];
	NSURL *servletURL = [[MCAppSettings sharedSettings] urlWithServletName:MCAsynchronousTestsServletName];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:servletURL];
	times.clientInitialRequest = [[NSDate date] timeIntervalSince1970];
	NSString *randomFileName = [NSString stringWithFormat:@"r-%@-", times.testID];
	[request addData:[NSData randomDataOfSize:MCDataSize1MB/3] withFileName:randomFileName andContentType:@"application/octet-stream" forKey:@"data"];
	[request addPostValue:times.testID forKey:@"testID"];
	[request startSynchronous];
	times.clientReceiveImmediateResponse = [[NSDate date] timeIntervalSince1970];
	
	return [times autorelease];
}
- (void)main
{
//	[[MCTimeSynchronizer sharedSynchronizer] startSyncingWithMCM];
//	DLog(@"I'm running i'm running... : Time difference is : %f", [[MCTimeSynchronizer sharedSynchronizer] calculateSyncDifference]);
	for (int i = 0; i < TIMES_TO_RUN; i++) {
		MCAsyncTestTimes *times = [self executeTest];
		[self.testTimes setValue:times forKey:times.testID];
	}
}
- (void)receivedTestResult:(NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
	NSString *testID = [userInfo objectForKey:@"testID"];
	MCAsyncTestTimes *times = [self.testTimes objectForKey:testID];
	times.clientReceivePushNotification = [[NSDate date] timeIntervalSince1970];
	[self syncTimesWithServerForTaskID:[userInfo objectForKey:@"testID"]];
}
- (id)init
{
	self = [super init];
	if (self) {
		testTimes = [[NSMutableDictionary alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedTestResult:) name:MCAsyncTestResultNotification object:nil];
		
	}
	return self;
}

- (void)dealloc
{
	[testTimes release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}
@end
