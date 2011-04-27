//
//  MCTimeSynchronizer.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 4/27/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCTimeSynchronizer.h"
#import "ASIFormDataRequest.h"
#import <dispatch/dispatch.h>

static int MCTimeSynchronizerNumberOfRepetitions = 100;

@implementation MCTimeSynchronizer

+ (MCTimeSynchronizer *)sharedSynchronizer
{
	static MCTimeSynchronizer *instance = nil;
	if (instance == nil) {
		instance = [[MCTimeSynchronizer alloc] init];
	}
	return instance;
}

- (void)addTimeDifference:(float)difference
{
	DLog(@"Got time difference : %f", difference);
}

- (void)startSyncingWithMCM
{
	void (^SimpleBlock)(int) = ^(int num) {
		[NSThread sleepForTimeInterval:num];
	};
	dispatch_queue_t queue = dispatch_queue_create("ee.ut.cs.ds.mobilecloud.MCM", NULL);
	dispatch_queue_t main = dispatch_get_main_queue();
	
	dispatch_async(queue, ^{
		SimpleBlock(4);
		dispatch_async(main, ^{ // Give the results back to caller
			[self addTimeDifference:0.001];
		});
	});
	
}

@end
