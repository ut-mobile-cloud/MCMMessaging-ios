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

static int TIMES_TO_RUN = 10;

@implementation MCSynchronousTests

- (NSString *)description
{
	return @"Invoke services form MCM using synchronous communication";
}

- (NSString *)name
{
	return @"Sync";
}

- (double)getTaskTimeFromMCM
{
	return -1;
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
- (NSDictionary *)executeTest
{
	NSMutableDictionary *results = [[NSMutableDictionary alloc] initWithCapacity:0];
	NSURL *servlet = [[MCAppSettings sharedSettings] urlWithServletName:@"SynchronousTestsServlet"];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:servlet];
	double totalTimeStart = CACurrentMediaTime();
	[request startSynchronous];
	double totalTimeDuration = CACurrentMediaTime() - totalTimeStart;
	
	double taskTimeInMCM = [self getTaskTimeFromMCM];
	
	[results setObject:[NSNumber numberWithDouble:totalTimeDuration] forKey:@"totalTime"];
	[results setObject:[NSNumber numberWithDouble:taskTimeInMCM] forKey:@"taskInMCM"];
	DLog(@"Test completed. Times:\n\t total : %f\n\t in MCM: %f", totalTimeDuration, taskTimeInMCM);
	return [results autorelease];
}

- (void)main
{
	NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];
	for (int i = 0; i < TIMES_TO_RUN; i++) {
		[results addObject:[self executeTest]];
	}
	DLog(@"%@", results);
}

@end
