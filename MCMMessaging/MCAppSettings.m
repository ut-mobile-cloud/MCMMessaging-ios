//
//  MCAppSettings.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/9/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCAppSettings.h"

static NSString *MCServerIPAddress = @"172.17.36.184";
static NSString *MCServerPort = @"8084";

@implementation MCAppSettings

+ (MCAppSettings *)sharedSettings
{
	static MCAppSettings *appSettingsInstance = nil;
	if (appSettingsInstance == nil) {
		appSettingsInstance = [[MCAppSettings alloc] init];
		[[NSUserDefaults standardUserDefaults] setValue:MCServerIPAddress forKey:@"serverURL"];
		[[NSUserDefaults standardUserDefaults] setValue:MCServerPort forKey:@"serverPort"];
		
	}
	return appSettingsInstance;
}

- (NSString *)serverIP
{
	return [[NSUserDefaults standardUserDefaults] valueForKey:@"serverURL"];
}

- (NSString *)serverPort
{
	return [[NSUserDefaults standardUserDefaults] valueForKey:@"serverPort"];
}

- (NSURL *)urlWithServletName:(NSString *)servletName;
{
	NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/%@", [self serverIP], [self serverPort], servletName, nil];
	DLog(@"servlet is at: %@", urlString);
	NSURL *url = [NSURL URLWithString:urlString];
	return url;
}

@end
