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
@synthesize taskDescriptionLabel;

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
		self.taskDescriptionLabel.text = task.description;
		if ([self->task respondsToSelector:@selector(name)]) {
			self.taskNameLabel.text = [self->task performSelector:@selector(name)];
		} else if ([self->task respondsToSelector:@selector(serverTaskClassName)]) {
			self.taskNameLabel.text = [self->task performSelector:@selector(serverTaskClassName)];
		} else {
			self.taskNameLabel.text = @"Task";
		}
	} else if ([dataObject isKindOfClass:[NSString class]]) {
		self.taskNameLabel.text = (NSString *)dataObject;
	} else {
		self.taskNameLabel.text = @"Unknown task";
	}
}

- (void)dealloc {
	[taskNameLabel release];
	[taskDescriptionLabel release];
	[super dealloc];
}
@end
