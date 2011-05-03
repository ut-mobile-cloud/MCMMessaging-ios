//
//  MCSyncTestTimes.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 5/3/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCSyncTestTimes.h"
#import "NSString+Additions.h"
#import "NSData+Additions.h"
#import "JSON.h"
@implementation MCSyncTestTimes

@synthesize clientInitialRequest, clientReceiveResponse, serverReceiveInitialRequest, serverRequestToCloud, serverResponseFromCloud, serverSendResponse, testID;

- (id)init
{
	self = [super init];
	if (self) {
		NSTimeInterval timePart = [[NSDate date] timeIntervalSince1970];
		NSString *uniqueString = [NSString stringWithFormat:@"%f%@", timePart, [NSData randomDataOfSize:128]];
		testID = [[uniqueString MD5] retain];
		clientInitialRequest = -1;
		serverReceiveInitialRequest = -1;
		serverRequestToCloud = -1;
		serverResponseFromCloud = -1;
		serverSendResponse = -1;
		clientReceiveResponse = -1;
	}
	return self;
}

- (NSString *)JSONRepresentation
{
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:testID forKey:@"testID"];
	[dict setObject:[NSNumber numberWithDouble:clientInitialRequest] forKey:@"clientInitialRequest"];
	[dict setObject:[NSNumber numberWithDouble:serverReceiveInitialRequest] forKey:@"serverReceiveInitialRequest"];
	[dict setObject:[NSNumber numberWithDouble:serverRequestToCloud] forKey:@"serverRequestToCloud"];
	[dict setObject:[NSNumber numberWithDouble:serverResponseFromCloud] forKey:@"serverResponseFromCloud"];
	[dict setObject:[NSNumber numberWithDouble:serverSendResponse] forKey:@"serverSendResponse"];
	[dict setObject:[NSNumber numberWithDouble:clientReceiveResponse] forKey:@"clientReceiveResponse"];
	 
	return [dict JSONRepresentation];
}

- (NSString *)description
{
	NSString *superDescription = [super description];
	NSMutableString *description = [[NSMutableString alloc] init];
	[description appendFormat:@"%@\n", superDescription];
	[description appendFormat:@"\ttestID : %@\n", testID];
	[description appendFormat:@"\tclientInitialRequest : %f\n", clientInitialRequest];
	[description appendFormat:@"\tclientReceiveResponse : %f\n", clientReceiveResponse];
	return [description autorelease];
}
- (void)dealloc
{
	[testID release];
	[super dealloc];
}
@end
