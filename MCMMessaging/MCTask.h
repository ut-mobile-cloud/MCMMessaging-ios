//
//  MCTask.h
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/2/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCTask : NSObject {
	@private
	NSString *description;
	NSMutableArray *parameters;
	NSString *taskID;
	NSString *serverTaskClassName;
	NSData *data;
}

@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, readonly) NSMutableArray *parameters;
@property (nonatomic, readonly) NSString *taskID;
@property (nonatomic, readonly) NSString *deviceID; // Should be read from application bundle where it has to be saved on 1-st launch
@property (nonatomic, readonly) NSString *serverTaskClassName;

+ (MCTask *)taskWithServerClass:(NSString *)serverClassName parameters:(NSArray *)parameters data:(NSData *)data description:(NSString *)description;
//+ (NSString *)serverTaskClassName;

- (id)initWithServerClassName:(NSString *)serverClassName;

@end
