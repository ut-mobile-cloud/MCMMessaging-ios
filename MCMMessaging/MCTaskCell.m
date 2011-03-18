//
//  MCTaskCell.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 2/21/11.
//  Copyright 2011 Indilo Wireless. All rights reserved.
//

#import "MCTaskCell.h"
#import "MCTaskRunner.h"
#import "MCTask.h"

@implementation MCTaskCell
@synthesize taskNameLabel;

+ (NSString *)nibName
{
	return @"MCTaskCell";
}

- (void)handleSelectionInTableView:(UITableView *)aTableView
{
	[super handleSelectionInTableView:aTableView];
	[MCTaskRunner runTask:task];
}

- (void)configureForData:(id)dataObject tableView:(UITableView *)aTableView indexPath:(NSIndexPath *)anIndexPath
{
	[super configureForData:dataObject tableView:aTableView indexPath:anIndexPath];
	if ([dataObject isKindOfClass:[MCTask class]]) {
		self->task = (MCTask *)[dataObject retain];
		self.taskNameLabel.text = task.description;
	} else if ([dataObject isKindOfClass:[NSString class]]) {
		self.taskNameLabel.text = (NSString *)dataObject;
	} else {
		self.taskNameLabel.text = @"Unknown task";
	}
}

- (void)dealloc {
	[taskNameLabel release];
	[super dealloc];
}
@end
