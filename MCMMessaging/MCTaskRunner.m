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

/*
 * When running tasks, task runner will check following things
 *	1) if there is a serverTaskClass property specifie (!=nil) -- if YES, it will try to run the task in server
 *	2) if there is no serverTaskClass property it will check for main selector -- if YES, will put the selected task to OperationQueue for running. This means that the task is expected to have all functionality to run itself.
 *	3) report error
 */
+ (void)runTask:(MCTask *)task
{
	static MCTaskRunner *instance = nil;
	if (instance == nil) {
		instance = [[MCTaskRunner alloc] init];
	}
	
	if (task.serverTaskClassName != nil) {
		[instance runRemoteTask:task];
	} else if ([task respondsToSelector:@selector(main)]){
		[instance runLocalTask:task];
	} else {
		DLog(@"ERROR : Could not find a way to run task!");
	}
}

- (void)runLocalTask:(MCTask *)task
{
	if ([task respondsToSelector:@selector(main)]) {
		NSInvocationOperation *taskInvocation = [[NSInvocationOperation alloc] initWithTarget:task selector:@selector(main) object:nil];
		[localTasks addOperation:taskInvocation];
		[taskInvocation release];
	} else {
		DLog(@"task did not have main()");
	}
}

- (void)runRemoteTask:(MCTask *)task
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

- (id)init
{
	self = [super init];
	if (self) {
		localTasks = [[NSOperationQueue alloc] init];
	}
	return self;
}

- (void)dealloc
{
	//! TODO: check if operations are finished?
	[localTasks release];
	[super dealloc];
}
@end

