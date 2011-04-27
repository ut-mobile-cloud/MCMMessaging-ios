//
//  NSData+Additions.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/2/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "NSData+Additions.h"


@implementation NSData(Additions)

- (NSString *)stringWithHexBytes
{
	static const char hexdigits[] = "0123456789ABCDEF";
	const size_t numBytes = [self length];
	const unsigned char* bytes = [self bytes];
	char *strbuf = (char *)malloc(numBytes * 2 + 1);
	char *hex = strbuf;
	NSString *hexBytes = nil;
	
	for (int i = 0; i<numBytes; ++i) {
		const unsigned char c = *bytes++;
		*hex++ = hexdigits[(c >> 4) & 0xF];
		*hex++ = hexdigits[(c ) & 0xF];	
	}
	*hex = 0;
	hexBytes = [NSString stringWithUTF8String:strbuf];
	free(strbuf);
	return hexBytes;
}

+ (NSData *)randomDataOfSize:(int)size
{
	NSMutableData *data = [NSMutableData dataWithCapacity:size];
	for (int i = 0; i < size/4; i++) {
		u_int32_t randomBits = arc4random();
		[data appendBytes:(void *)&randomBits length:sizeof(randomBits)];
	}
	return data;
}

@end
