//
//  MCSyncTestTimes.h
//  MCMMessaging
//
//  Created by Madis Nõmme on 5/3/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCSyncTestTimes : NSObject {
	@private
	NSString *testID;
	// Timestamps
    double clientInitialRequest; // client makes initial requet
    double serverReceiveInitialRequest; // server receives request
    double serverRequestToCloud; // server makes request to cloud
    double serverResponseFromCloud; // server gets response
    double serverSendResponse; // Timestamp when server sends response to client
    double clientReceiveResponse; // Timestamp when client receives the response
}

@property (nonatomic, retain) NSString *testID;
@property (nonatomic, assign) double clientInitialRequest;
@property (nonatomic, assign) double serverReceiveInitialRequest;
@property (nonatomic, assign) double serverRequestToCloud;
@property (nonatomic, assign) double serverResponseFromCloud;
@property (nonatomic, assign) double serverSendResponse;
@property (nonatomic, assign) double clientReceiveResponse;

- (NSString *)JSONRepresentation;

@end
