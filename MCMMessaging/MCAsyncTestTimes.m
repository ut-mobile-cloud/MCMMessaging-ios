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
#import "JSON.h"

@implementation MCAsyncTestTimes

@synthesize clientInitialRequest,clientReceiveImmediateResponse, clientReceivePushNotification, serverReceiveInitialRequest, serverRequestToCloud, serverResponseFromCloud, serverSendImmediateResponse, serverSendPushNotification, testID;

- (NSString *)JSONRepresentation
{
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:testID forKey:@"testID"];
	[dict setObject:[NSNumber numberWithDouble:clientInitialRequest] forKey:@"clientInitialRequest"];
	[dict setObject:[NSNumber numberWithDouble:serverReceiveInitialRequest] forKey:@"serverReceiveInitialRequest"];
	[dict setObject:[NSNumber numberWithDouble:serverSendImmediateResponse] forKey:@"serverSendImmediateResponse"];
	[dict setObject:[NSNumber numberWithDouble:clientReceiveImmediateResponse] forKey:@"clientReceiveImmediateResponse"];
	[dict setObject:[NSNumber numberWithDouble:serverRequestToCloud] forKey:@"serverRequestToCloud"];
	[dict setObject:[NSNumber numberWithDouble:serverResponseFromCloud] forKey:@"serverResponseFromCloud"];
	[dict setObject:[NSNumber numberWithDouble:serverSendPushNotification] forKey:@"serverSendPushNotification"];
	[dict setObject:[NSNumber numberWithDouble:clientReceivePushNotification] forKey:@"clientReceivePushNotification"];

	return [dict JSONRepresentation];
}

- (NSString *)description
{
	NSMutableString *desc = [NSMutableString stringWithCapacity:0];
	[desc appendFormat:@"Async test times\n"];
	[desc appendFormat:@"\tclientInitialRequest : %f\n", clientInitialRequest];
	[desc appendFormat:@"\tserverReceiveInitialRequest : %f\n", serverReceiveInitialRequest];
	[desc appendFormat:@"\tserverSendImmediateResponse : %f\n", serverSendImmediateResponse];
	[desc appendFormat:@"\tclientReceiveImmediateResponse : %f\n", clientReceiveImmediateResponse];
	[desc appendFormat:@"\tserverRequestToCloud : %f\n", serverRequestToCloud];
	[desc appendFormat:@"\tserverResponseFromCloud : %f\n", serverResponseFromCloud];
	[desc appendFormat:@"\tserverSendPushNotification : %f\n", serverSendPushNotification];
	[desc appendFormat:@"\tclientReceivePushNotification : %f", clientReceivePushNotification];
	return desc;
}

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
