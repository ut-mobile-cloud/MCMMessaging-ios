//
//  MCTaskTimes.h
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/9/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCTaskTimes : NSObject {
	@private
    NSString *taskID;
	NSString *description;
	float initiationTime;
	float runningTime;
	float notificationDelivery;
	float results;
}

@property (nonatomic, readonly) NSString *taskID;
@property (nonatomic, readonly) NSString *description;
@property (nonatomic, assign) float initiationTime;
@property (nonatomic, assign) float runningTime;
@property (nonatomic, assign) float notificationDelivery;
@property (nonatomic, assign) float results;

+ (void)sendTimesToServer:(MCTaskTimes *)times;
- (id)initWithTaskID:(NSString *)theTaskID;
- (id)initWithDict:(NSDictionary *)dict;
- (float)total;
- (NSString *)json;

@end
