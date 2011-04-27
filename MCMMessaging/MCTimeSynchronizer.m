//
//  MCTimeSynchronizer.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 4/27/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCTimeSynchronizer.h"
#import "ASIFormDataRequest.h"

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

- (void)startSyncingWithMCM
{
	
}

@end
