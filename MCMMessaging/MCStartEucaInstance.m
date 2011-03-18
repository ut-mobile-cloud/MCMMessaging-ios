//
//  MCStartEucaInstance.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/8/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCStartEucaInstance.h"


@implementation MCStartEucaInstance

+ (MCStartEucaInstance *)newUsingDefaultValues
{
	MCStartEucaInstance *startEuca = [[MCTask alloc] initWithServerClassName:@"StartEucaInstanceTask"];
	startEuca.description = @"Starts Eucalyptus instance";
	// TODO: those should be asked from user. Values here are for testing only
	NSString *key = @"qWmzuvv8MvADE2TgduZ9RGXsnUaJ1EOBtbhiew";
	NSString *secretKey = @"zUBBWleQPSSPDO8XpfmKjT9fJvEoouSLuFIJ8g";
	NSString *imageName = @"emi-DB2F1551";
	[startEuca.parameters addObjectsFromArray:[NSArray arrayWithObjects:key, secretKey, imageName, nil]];
	return [startEuca autorelease];
}

@end
