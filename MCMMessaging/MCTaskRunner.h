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
    
}

+ (void)runTask:(MCTask *)task;

@end
