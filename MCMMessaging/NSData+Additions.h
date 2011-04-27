//
//  NSData+Additions.h
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/2/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (Additions)

- (NSString *)stringWithHexBytes;
+ (NSData *)randomDataOfSize:(int)size;

@end
