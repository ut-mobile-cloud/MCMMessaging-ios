//
//  MCSynchronousTests.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 4/25/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCSynchronousTests.h"
#import "ASIFormDataRequest.h"
#import "MCAppSettings.h"
#import <QuartzCore/QuartzCore.h>
#import "MCSyncTestTimes.h"
#import "NSData+Additions.h"
#import "JSON.h"

static int TIMES_TO_RUN = 2;
static NSString *MCSynchronousTestsServletName = @"SyncTestsServlet";
static int MCDataSize1MB = 1048576;

@implementation MCSynchronousTests

- (NSString *)description
{
	return @"Invoke services form MCM using synchronous communication";
}

- (NSString *)name
{
	return @"Sync";
}

/**
 *	TODO: change(update) the object that is passed into this method. You should not create a new object. I think this way is better. Madis.
 */
- (MCSyncTestTimes *)joinTimesWithTimesFromMCM:(MCSyncTestTimes *)times
{
	NSURL *mcmSyncTimesServletURL = [[MCAppSettings sharedSettings] urlWithServletName:@"RequestTestTimesServlet"];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:mcmSyncTimesServletURL];
	[request addPostValue:@"SyncTests" forKey:@"testType"];
	[request addPostValue:times.testID forKey:@"testID"];
	[request addPostValue:[times JSONRepresentation] forKey:@"clientTimes"];
	[request startSynchronous];
	MCSyncTestTimes *newTimes = nil;
	NSError *error = [request error];
	if (!error && [request responseStatusCode] == 200) {
		NSString *responseJson = [request responseString];
		SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
		id jsonObject = [jsonParser objectWithString:responseJson];
		if ([jsonObject isKindOfClass:[MCSyncTestTimes class]]) {
			newTimes = (MCSyncTestTimes *)jsonObject;
		}
	}
	return [newTimes autorelease];
}

/**
 *	@brief Moves remote data using synchronous communication with MCM and measures times.
 *
 *	Will move data between clouds (or other remote storage resources) and measure following time parameters:
 *		1. total time taken - measured in phone
 *		2. time taken in MCM to complete the task - requested from MCM
 *		3. server overhead (total time spent in server - time spent for requested task). Calculated as follows:
 *			1) immediately when request is received by server timer is started
 *			2) 
 */
- (MCSyncTestTimes *)executeTest
{
	MCSyncTestTimes *times = [[MCSyncTestTimes alloc] init];
	
	NSURL *servlet = [[MCAppSettings sharedSettings] urlWithServletName:MCSynchronousTestsServletName];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:servlet];
	times.clientInitialRequest = [[NSDate date] timeIntervalSince1970];
	NSString *randomFileName = [NSString stringWithFormat:@"r-%@-", times.testID];
	[request addData:[NSData randomDataOfSize:MCDataSize1MB] withFileName:randomFileName andContentType:@"application/octet-stream" forKey:@"data"];
	[request addPostValue:times.testID forKey:@"testID"];
	[request startSynchronous];
	times.clientReceiveResponse = [[NSDate date] timeIntervalSince1970];
	DLog(@"Test completed. %@", times);
	return [times autorelease];
}

- (void)main
{
	NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];
	for (int i = 0; i < TIMES_TO_RUN; i++) {
		MCSyncTestTimes *times = [self executeTest];
		//[self joinTimesWithTimesFromMCM:times];
		[results addObject:times];
		
	}
}

@end
