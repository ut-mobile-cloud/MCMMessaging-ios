//
//  MCTask.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/2/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCTask.h"
#import "MCNotificationManager.h"
#import "NSString+Additions.h"

static NSString *MCEmptyServerTaskClassName = @"NoOpTask";

@implementation MCTask
@synthesize data, description, parameters, taskID, serverTaskClassName;

//+ (NSString *)serverTaskClassName
//{
//	return MCEmptyServerTaskClassName;
//}

+ (MCTask *)taskWithServerClass:(NSString *)serverClass parameters:(NSArray *)parameters data:(NSData *)data description:(NSString *)description
{
	DLog(@"Creating a new task instance : serverClass == %@", serverClass);
	MCTask *newTask = [[MCTask alloc] initWithServerClassName:serverClass];
	newTask.description = description;
	[newTask.parameters addObjectsFromArray:parameters];
	if (data != nil) {
		newTask.data = data;
	}
	return [newTask autorelease];
}

@dynamic deviceID;
- (NSString *)deviceID
{
	return [[MCNotificationManager sharedManager] deviceID];
}

#pragma mark NSObject
- (id)initWithServerClassName:(NSString *)serverClassName
{
	self = [super init];
	if (self) {
		if (serverClassName == nil) {
			serverClassName = MCEmptyServerTaskClassName;
		}
		serverTaskClassName = [serverClassName retain];
		parameters = [[NSMutableArray arrayWithCapacity:0] retain];
		NSTimeInterval timePart = [[NSDate date] timeIntervalSince1970];
		NSString *uniqueString = [NSString stringWithFormat:@"%f%@", timePart, [self deviceID]];
		taskID = [[uniqueString MD5] retain];
	}
	return self;
}

- (id)init
{
	self = [super init];
	if (self) {
		parameters = [[NSMutableArray arrayWithCapacity:0] retain];
		NSTimeInterval timePart = [[NSDate date] timeIntervalSince1970];
		NSString *uniqueString = [NSString stringWithFormat:@"%f%@", timePart, [self deviceID]];
		taskID = [[uniqueString MD5] retain];
	}
	return self;
}

- (void)dealloc
{
	[taskID release];
	[data release];
	[description release];
	[parameters release];
	[super dealloc];
}
@end
