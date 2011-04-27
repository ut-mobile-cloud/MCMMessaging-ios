//
//  MCTaskRunner.h
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/2/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCTask;
@interface MCTaskRunner : NSObject {
    NSOperationQueue *localTasks;
}

+ (void)runTask:(MCTask *)task;
- (void)runRemoteTask:(MCTask *)task;
- (void)runLocalTask:(MCTask *)task;
@end
