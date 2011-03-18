//
//  MCAppSettings.h
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/9/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCAppSettings : NSObject {
    
}

+ (MCAppSettings *)sharedSettings;
- (NSString *)serverIP;
- (NSString *)serverPort;
- (NSURL *)urlWithServletName:(NSString *)servletName;

@end
