//
//  MCTaskTimesCell.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/12/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCTaskTimesCell.h"
#import "MCTaskTimes.h"

@implementation MCTaskTimesCell
@synthesize description;
@synthesize runningTime;
@synthesize initiationTime;
@synthesize notificationDelivery;
@synthesize results;
@synthesize total;
@synthesize taskID;

NSString * FloatValueOrNA(float value)
{
	NSString *floatOrNA = nil;
	if (value < 0) {
		floatOrNA = @"N/A";
	} else {
		floatOrNA = [NSString stringWithFormat:@"%.3f", value];
	}
	return  floatOrNA;
}

+ (NSString *)nibName
{
	return @"MCTaskTimesCell";
}

- (void)configureForData:(id)dataObject tableView:(UITableView *)aTableView indexPath:(NSIndexPath *)anIndexPath
{
	[super configureForData:dataObject tableView:aTableView indexPath:anIndexPath];
	MCTaskTimes *times = (MCTaskTimes *)dataObject;
	self.description.text = times.description;
	self.initiationTime.text = [NSString stringWithFormat:@"%@", FloatValueOrNA(times.initiationTime)];
	self.runningTime.text = [NSString stringWithFormat:@"%@", FloatValueOrNA(times.runningTime)];
	self.notificationDelivery.text = [NSString stringWithFormat:@"%@", FloatValueOrNA(times.notificationDelivery)];
	self.results.text = [NSString stringWithFormat:@"%@", FloatValueOrNA(times.results)];
	self.total.text = [NSString stringWithFormat:@"%@", FloatValueOrNA([times total])];
	self.taskID.text = times.taskID;
	
	
	
}
- (void)dealloc {
	[description release];
	[runningTime release];
	[initiationTime release];
	[notificationDelivery release];
	[results release];
	[total release];
	[taskID release];
	[super dealloc];
}
@end
