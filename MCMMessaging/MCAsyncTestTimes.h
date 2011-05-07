//
//  MCAsyncTestTimes.h
//  MCMMessaging
//
//  Created by Madis Nõmme on 5/3/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCAsyncTestTimes : NSObject {
	@private
	NSString *testID; // Test identificator
	// Timestamps : 
    double clientInitialRequest; // client makes initial request to server
    double serverReceiveInitialRequest; // server receives initial request
    double serverSendImmediateResponse; // server starts sending back response for initial request. (Does it immediately. Async you know)
    double clientReceiveImmediateResponse; // client receives server's immediate response
    double serverRequestToCloud; // server makes request to cloud
    double serverResponseFromCloud; // server gets response from cloud (job should be done)
    double serverSendPushNotification; // server sends out push notification
    double clientReceivePushNotification; // client receives push notification
}

@property (nonatomic, retain) NSString *testID;
@property (nonatomic, assign) double clientInitialRequest;
@property (nonatomic, assign) double serverReceiveInitialRequest;
@property (nonatomic, assign) double serverSendImmediateResponse;
@property (nonatomic, assign) double clientReceiveImmediateResponse;
@property (nonatomic, assign) double serverRequestToCloud;
@property (nonatomic, assign) double serverResponseFromCloud;
@property (nonatomic, assign) double serverSendPushNotification;
@property (nonatomic, assign) double clientReceivePushNotification;

- (NSString *)JSONRepresentation;

@end
