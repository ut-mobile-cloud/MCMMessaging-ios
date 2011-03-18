//
//  NSString+Additions.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/2/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "NSString+Additions.h"
#import "md5.h"

@implementation NSString (NSString_Additions)

- (NSString *)MD5
{
	md5_state_t state;
	md5_byte_t digest[16];
	char hex_output[16*2 + 1];
	int di;
	const char *cStr = [self UTF8String];
	md5_init(&state);
	md5_append(&state, (const md5_byte_t *)cStr, strlen(cStr));
	md5_finish(&state, digest);
	for (di = 0; di < 16; ++di)
	    sprintf(hex_output + di * 2, "%02x", digest[di]);
	return [NSString stringWithUTF8String:hex_output];
}

@end
