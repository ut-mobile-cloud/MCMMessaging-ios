//
//  MCMessageCell.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/7/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCMessageCell.h"


@implementation MCMessageCell
@synthesize messageLabel;

+ (NSString *)nibName
{
	return @"MCMessageCell";
}

- (void)configureForData:(id)dataObject tableView:(UITableView *)aTableView indexPath:(NSIndexPath *)anIndexPath
{
	[super configureForData:dataObject tableView:aTableView indexPath:anIndexPath];
	self.messageLabel.text = (NSString *)dataObject;
}

- (void)handleSelectionInTableView:(UITableView *)aTableView
{
	DLog(@"%@", self.messageLabel.text);
}

- (void)dealloc {
	[messageLabel release];
	[super dealloc];
}
@end
