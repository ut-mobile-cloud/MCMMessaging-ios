//
//  MCMessagesController.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/7/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCMessagesController.h"
#import "MCNotificationManager.h"
#import "MCMessageCell.h"
#import "GradientBackgroundTable.h"
@implementation MCMessagesController

- (NSString *)title
{
	return @"Messages from server";
}

- (void)createRows
{
	[self addSectionAtIndex:0 withAnimation:UITableViewRowAnimationFade];
	NSArray *messages = [MCNotificationManager sharedManager].messages;
	NSInteger rowCount = messages.count;
	for (NSInteger i = 0; i < rowCount; i++) {
		[self appendRowToSection:0 cellClass:[MCMessageCell class] cellData:[messages objectAtIndex:i] withAnimation:(i % 2) == 0 ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight];
	}
}

- (void)loadView
{
	GradientBackgroundTable *aTableView =
	[[[GradientBackgroundTable alloc]
	  initWithFrame:CGRectZero
	  style:UITableViewStyleGrouped]
	 autorelease];
	
	self.view = aTableView;
	self.tableView = aTableView;
}

- (void)refresh:(id)sender
{
	[self removeAllSectionsWithAnimation:UITableViewRowAnimationFade];
	[self performSelector:@selector(createRows) withObject:nil afterDelay:0.5];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self refresh:nil];

}
- (void)addResultRow:(NSNotification *)notification
{
	NSString *rowData = [notification.userInfo objectForKey:@"newResult"];
	[self appendRowToSection:0 cellClass:[MCMessageCell class]
					cellData:rowData 
			   withAnimation:[MCNotificationManager sharedManager].messages.count % 2 == 0 ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addResultRow:) name:MCReceivedResultsNotification object:nil];
}

- (void)viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Messages from server";
}

- (id)init
{
	self = [super init];
	if(self) {
		DLog(@"Olen siin");
	}
	return self;
}

@end
