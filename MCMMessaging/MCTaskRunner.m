//
//  MCTaskRunner.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/2/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCTaskRunner.h"
#import "MCTask.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "MCAppSettings.h"
#import <QuartzCore/QuartzCore.h>
#import "MCTaskTimes.h"
#import "JSON.h"
@implementation MCTaskRunner

+ (void)runTask:(MCTask *)task
{
	/*
	 Parameters to this string template (IN THIS ORDER):
		1) job description: task.description
		2) device ID (token) : task.deviceID
		3) job ID: task.taskID
		4) parameters (as JSON array)
	 */
	NSString *jobDescriptionJSONTemplate = @"{ \
	\"description\" : \"%@\", \
	\"ownerDevice\" : \"iphone\", \
	\"deviceID\" : \"%@\", \
	\"taskID\" : \"%@\", \
	\"parameters\" : %@ \
	}";
	NSString *jobDescriptionJSON = [NSString stringWithFormat:jobDescriptionJSONTemplate, task.description, task.deviceID, task.taskID, [task.parameters JSONRepresentation]];
	NSURL *url = [[MCAppSettings sharedSettings] urlWithServletName:@"TaskManager"];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostFormat:ASIMultipartFormDataPostFormat];
	
	DLog(@"request will be with serverTaskClassName = %@ and task description = %@", task.serverTaskClassName, jobDescriptionJSON);
	[request addPostValue:task.serverTaskClassName forKey:@"taskClass"];
	[request addPostValue:jobDescriptionJSON forKey:@"taskDescription"];

	if (task.data != nil) {
		[request addData:task.data withFileName:@"jobufail.png" andContentType:@"image/png" forKey:@"data"];
	}
	double jobStartTime = CACurrentMediaTime();
	[request startSynchronous];
	double initDuration = CACurrentMediaTime() - jobStartTime;
	
	NSError *error = [request error];
	if(!error) {
		DLog(@"response : %@", [request responseString]);
		DLog(@"taskRunner : making taskTimes with taskID : %@", task.taskID);
		MCTaskTimes *newTimes = [[MCTaskTimes alloc] initWithTaskID:task.taskID];
		DLog(@"New made taskTimes taskID : %@", newTimes.taskID);
		newTimes.initiationTime = initDuration;
		[MCTaskTimes sendTimesToServer:newTimes];
		[newTimes release];
		
	} else {
		DLog(@"error : %@", error);
	}
	
}

@end
