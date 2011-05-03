//
//  MCTimeSynchronizer.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 4/27/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCTimeSynchronizer.h"
#import "MCAppSettings.h"
#import "ASIFormDataRequest.h"
#import <dispatch/dispatch.h>

static int MCTimeSynchronizerNumberOfRepetitions = 10;
static NSString *MCLocalStartKey = @"MCLocalStartKey";
static NSString *MCLocalEndKey = @"MCLocalEndKey";
static NSString *MCServerTimeKey = @"MCServerTimeKey";

@implementation MCTimeSynchronizer

+ (MCTimeSynchronizer *)sharedSynchronizer
{
	static MCTimeSynchronizer *instance = nil;
	if (instance == nil) {
		instance = [[MCTimeSynchronizer alloc] init];
	}
	return instance;
}

- (void)storeLocalStart:(double)localStart localEnd:(double)localEnd serverTime:(double)serverTime
{
	NSArray *timeValues = [NSArray arrayWithObjects:
						   [NSNumber numberWithDouble:localStart],
						   [NSNumber numberWithDouble:localEnd],
						   [NSNumber numberWithDouble:serverTime],
						   nil];
	NSArray *timeKeys = [NSArray arrayWithObjects:MCLocalStartKey, MCLocalEndKey, MCServerTimeKey, nil];
	
	NSDictionary *newTimes = [NSDictionary dictionaryWithObjects:timeValues forKeys:timeKeys];
	[timeStamps addObject:newTimes];
	DLog(@"There are %d values in array", [timeStamps count]);
}

- (double)calculateSyncDifference
{
	double averageDifference = 0;
	for (NSDictionary *times in timeStamps) {
		double localStart = [[times objectForKey:MCLocalStartKey] doubleValue];
		double localEnd = [[times objectForKey:MCLocalEndKey] doubleValue];
		double serverTime = [[times objectForKey:MCServerTimeKey] doubleValue];
		
		double difference = (localStart + (localEnd - localStart) / 2) - serverTime;
		averageDifference += difference;
	}
	averageDifference /= [timeStamps count];
	return averageDifference;
}

- (void)startSyncingWithMCM
{
	dispatch_queue_t queue = dispatch_queue_create("ee.ut.cs.ds.mobilecloud.MCM", NULL);
	dispatch_queue_t main = dispatch_get_main_queue();
	
	void (^MCMSyncRequestBlock)(void) = ^(void) {
		NSURL *url = [[MCAppSettings sharedSettings] urlWithServletName:@"TimeSyncServlet"];
		for (int i = 0; i < MCTimeSynchronizerNumberOfRepetitions; i++) {
			ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
			double timeStampBeforeRequest = [[NSDate date] timeIntervalSince1970];
			[request startSynchronous];
			double timeStampAfterRequest = [[NSDate date] timeIntervalSince1970];
			
			NSError *error = [request error];
			if (error == nil && [request responseStatusCode] == 200) {
				NSString *responseMillis = [request responseString];
				double serverCurrentTimeMillis = [responseMillis doubleValue]/1000;
				DLog(@"Ta:%f Tb:%f Tc:%f", timeStampBeforeRequest, timeStampAfterRequest, serverCurrentTimeMillis);
				double timeDifference = 0.666; // TODO: implement actual calculation
				dispatch_sync(main, ^{
					[self storeLocalStart:timeStampBeforeRequest localEnd:timeStampAfterRequest serverTime:serverCurrentTimeMillis];
				});
			}
		}
	};
	
	dispatch_async(queue, MCMSyncRequestBlock);
	
}

#pragma mark NSObject
- (id)init
{
	self = [super init];
	if (self) {
		timeStamps = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	// TODO: maybe should worry about stopping block jobs running in background?
	[timeStamps release];
	[super dealloc];
}
@end
