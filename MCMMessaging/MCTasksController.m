//
//  MCTasksController.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 2/21/11.
//  Copyright 2011 Indilo Wireless. All rights reserved.
//

#import "MCTasksController.h"
#import "MCTaskCell.h"
#import "GradientBackgroundTable.h"
#import "MCUploadPictureCell.h"
#import "MCTask.h"
#import "MCStartEucaInstance.h"
#import "MCDirectTests.h"
#import "MCSynchronousTests.h"
#import "MCAsynchronousTests.h"

@implementation MCTasksController

- (void)createRows
{
	[self addSectionAtIndex:0 withAnimation:UITableViewRowAnimationFade];
	[self appendRowToSection:0 cellClass:[MCTaskCell class] 
					cellData:[MCDirectTests new]
			   withAnimation:UITableViewRowAnimationLeft];
	[self appendRowToSection:0 cellClass:[MCTaskCell class] 
					cellData:[MCSynchronousTests new]
			   withAnimation:UITableViewRowAnimationLeft];
	[self appendRowToSection:0 cellClass:[MCTaskCell class] 
					cellData:[MCAsynchronousTests new]
			   withAnimation:UITableViewRowAnimationLeft];

	
	[self addSectionAtIndex:1 withAnimation:UITableViewRowAnimationFade];
	NSArray *addends = [NSArray arrayWithObjects:
						[NSNumber numberWithInt:1],
						[NSNumber numberWithInt:2],
						[NSNumber numberWithInt:3],
						[NSNumber numberWithInt:4],
						[NSNumber numberWithInt:5],nil];
	
	[self appendRowToSection:1 cellClass:[MCTaskCell class] 
					cellData:[MCTask taskWithServerClass:@"CalculateSumTask"
											  parameters:addends
													data:nil
											 description:@"Calculates the sum"]
			   withAnimation:UITableViewRowAnimationRight];
	
	[self appendRowToSection:1 cellClass:[MCTaskCell class] 
					cellData:[MCTask taskWithServerClass:@"WaitingTask"
											  parameters:[NSArray arrayWithObject:[NSNumber numberWithInt:8]]
													data:nil
											 description:@"Will wait for some time"]
			   withAnimation:UITableViewRowAnimationRight];
	
	[self appendRowToSection:1 cellClass:[MCUploadPictureCell class] 
					cellData:[MCTask taskWithServerClass:@"UploadPictureTask" 
											  parameters:nil
													data:nil 
											 description:@"Will let you select a picture and then upload it to server"] 
			   withAnimation:UITableViewRowAnimationLeft];

	[self appendRowToSection:1 cellClass:[MCTaskCell class] 
					cellData:[MCStartEucaInstance newUsingDefaultValues]
			   withAnimation:UITableViewRowAnimationLeft];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 1) {
		return @"MCM Tasks";
	} else if (section == 0) {
		return @"Performance tests";
	}
	return nil;
}

#pragma mark UIViewController

- (void)loadView
{
	GradientBackgroundTable *aTableView = [[[GradientBackgroundTable alloc] initWithFrame:CGRectZero 
																				   style:UITableViewStyleGrouped] autorelease];
	self.view = aTableView;
	self.tableView = aTableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.useCustomHeaders = YES;
	[self createRows];
}

#pragma mark NSObject

- (void)dealloc
{
    [super dealloc];
}


@end
