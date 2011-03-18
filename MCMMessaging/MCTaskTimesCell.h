//
//  MCTaskTimesCell.h
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/12/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageCell.h"

@interface MCTaskTimesCell : PageCell {
    
	UILabel *description;
	UILabel *runningTime;
	UILabel *initiationTime;
	UILabel *notificationDelivery;
	UILabel *results;
	UILabel *total;
	UILabel *taskID;
}
@property (nonatomic, retain) IBOutlet UILabel *description;
@property (nonatomic, retain) IBOutlet UILabel *runningTime;
@property (nonatomic, retain) IBOutlet UILabel *initiationTime;
@property (nonatomic, retain) IBOutlet UILabel *notificationDelivery;
@property (nonatomic, retain) IBOutlet UILabel *results;
@property (nonatomic, retain) IBOutlet UILabel *total;
@property (nonatomic, retain) IBOutlet UILabel *taskID;

@end
