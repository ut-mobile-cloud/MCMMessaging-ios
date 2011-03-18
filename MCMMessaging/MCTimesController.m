//
//  MCTimesController.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/9/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCTimesController.h"
#import "LabelCell.h"
#import "ASIFormDataRequest.h"
#import "MCAppSettings.h"
#import "JSON.h"
#import "MCTaskTimes.h"
#import "MCTaskTimesCell.h"

static NSString *MCTaskTimesServletName = @"TaskTimesManager";

@implementation MCTimesController
@synthesize times;


//- (void)loadView
//{
//	DLog(@"1. loadView was called");
//	if (times == nil) {
//		times = [[NSMutableArray arrayWithCapacity:0] retain];
//	}
//}
//
//- (void)requestTimesFromServer
//{	
//	DLog(@"5. requestTimesFromServer");
//}
//

//- (void)viewWillAppear:(BOOL)animated
//{
//	DLog(@"3. viewWillAppear");
//	//[super viewWillAppear:animated];
//}

- (void)requestTimesFromServer
{
	//[self addSectionAtIndex:0 withAnimation:UITableViewRowAnimationFade];
	NSURL *requestURL = [[MCAppSettings sharedSettings] urlWithServletName:MCTaskTimesServletName];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requestURL];
	[request addPostValue:@"getAllTimes" forKey:@"action"];
	[request startSynchronous];
	
	NSError *error = [request error];
	if (!error) {
		NSString *responseString = [request responseString];
		NSArray *parsedTimes = [responseString JSONValue];
		[self.times removeAllObjects];
		DLog(@"Got %d values from server", parsedTimes.count);
		int rowNr = 0;
		for (NSDictionary *time in parsedTimes) {
			MCTaskTimes *newTimes = [[MCTaskTimes alloc] initWithDict:time];
			//[self.times addObject:newTimes];
			[self appendRowToSection:0
						   cellClass:[MCTaskTimesCell class]
							cellData:newTimes
					   withAnimation:rowNr % 2 == 0 ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight];
//			[newTimes release];
			rowNr += 1;
		}
		
		DLog(@"Times : %@", parsedTimes);
	} else {
		DLog(@"Error requesting times from server");
	}
}

- (NSString *)nibName
{
	return @"MCTimesController";
}


- (void)viewDidLoad
{
	[super viewDidLoad];
	if (self.times == nil) {
		self.times = [NSMutableArray arrayWithCapacity:0];
	}
	self.useCustomHeaders = YES;
	[self requestTimesFromServer];	
}

- (IBAction)refreshPushed:(id)sender {
	NSArray *baba = [self allDataInSection:0];
	for (int i = 0; i < baba.count; i++) {
		[self removeRowAtIndex:i inSection:0 withAnimation:UITableViewRowAnimationLeft];
	}
	[self performSelector:@selector(requestTimesFromServer) withObject:nil afterDelay:0.5];
}
//
- (IBAction)clearRecordsPushed:(id)sender {
	DLog(@"clearRecordsPushed");
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[[MCAppSettings sharedSettings] urlWithServletName:@"TaskTimesManager"]];
	[request addPostValue:@"clearRecords" forKey:@"action"];
	
	[request startSynchronous];
	NSError *error = [request error];
	NSString *alertMessage = @"nothing here";
	if (!error) {
		alertMessage = [request responseString];

	} else {
		alertMessage = [error domain];
	}
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message from server" 
														message:alertMessage
													   delegate:self cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	[self refreshPushed:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Task times";
}

- (void)dealloc
{
	[times release];
    [super dealloc];
}


@end
