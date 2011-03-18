//
//  MCTaskTimes.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/9/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCTaskTimes.h"
#import "ASIFormDataRequest.h"
#import "MCAppSettings.h"

@implementation MCTaskTimes

@synthesize taskID, initiationTime, runningTime, notificationDelivery, results, description;

+ (void)sendTimesToServer:(MCTaskTimes *)times
{
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[MCAppSettings sharedSettings] urlWithServletName:@"TaskTimesManager"]];
	DLog(@"sendTimesToServer : %@", times.taskID);
	[request addPostValue:@"UpdateTimes" forKey:@"action"];
	[request addPostValue:[times json] forKey:@"taskTimes"];
	[request addPostValue:times.taskID forKey:@"taskID"];
	[request startSynchronous];
}

- (NSString *)json
{
	NSMutableString *jsonString = [NSMutableString string];
	[jsonString appendFormat:@"{"];
	[jsonString appendFormat:@"\"description\": \"%@\",", self.description];
	[jsonString appendFormat:@"\"initiationTime\":%f,", self.initiationTime];
	[jsonString appendFormat:@"\"notificationDelivery\":%f,", self.notificationDelivery];
	[jsonString appendFormat:@"\"results\":%f,", self.results];
	[jsonString appendFormat:@"\"runningTime\":%f,", self.runningTime];
	[jsonString appendFormat:@"\"taskID\":\"%@\"", self.taskID];
	[jsonString appendFormat:@"}"];
	
	return jsonString;
}

- (float)total
{
	float total = 0;
	total += initiationTime < 0 ? 0 : initiationTime;
	total += runningTime < 0 ? 0 : runningTime;
	total += notificationDelivery < 0 ? 0 : notificationDelivery;
	total += results < 0 ? 0 : results;
	return total;
}
- (id)initWithTaskID:(NSString *)theTaskID
{
	self = [super init];
	if (self) {
		taskID = [theTaskID retain];
		initiationTime = -1;
		runningTime = -1;
		notificationDelivery = -1;
		results = -1;
	}
	return self;
}

- (id)initWithDict:(NSDictionary *)dict
{
	self = [super init];
	if (self) {
		taskID = [[dict objectForKey:@"taskID"] retain];
		description = [[dict objectForKey:@"description"] retain];
		runningTime = [[dict objectForKey:@"runningTime"] floatValue];
		initiationTime = [[dict objectForKey:@"initiationTime"] floatValue];
		notificationDelivery = [[dict objectForKey:@"notificationDelivery"] floatValue];
		results = [[dict objectForKey:@"results"] floatValue];
	}
	return self;
}


- (void)dealloc
{
	[description release];
	[taskID release];
	[super dealloc];
}

@end
