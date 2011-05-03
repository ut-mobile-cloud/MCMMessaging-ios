//
//  MCAsyncTestTimes.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 5/3/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCAsyncTestTimes.h"
#import "NSString+Additions.h"
#import "NSData+Additions.h"

@implementation MCAsyncTestTimes

@synthesize clientInitialRequest,clientReceiveImmediateResponse, clientReceivePushNotification, serverReceiveInitialRequest, serverRequestToCloud, serverResponseFromCloud, serverSendImmediateResponse, serverSendPushNotification, testID;

- (id)init
{
	self = [super init];
	if (self) {
		NSTimeInterval timePart = [[NSDate date] timeIntervalSince1970];
		NSString *uniqueString = [NSString stringWithFormat:@"%f%@", timePart, [NSData randomDataOfSize:128]];
		testID = [[uniqueString MD5] retain];
		
		clientInitialRequest = -1;
		serverReceiveInitialRequest = -1;
		serverSendImmediateResponse = -1;
		clientReceiveImmediateResponse = -1;
		serverRequestToCloud = -1;
		serverResponseFromCloud = -1;
		serverSendPushNotification = -1;
		clientReceivePushNotification = -1;
	}
	return self;
}

- (void)dealloc
{
	[testID release];
	[super dealloc];
}

@end
