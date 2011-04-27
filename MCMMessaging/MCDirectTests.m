//
//  MCDirectTests.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 4/25/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCDirectTests.h"
#import "NSData+Additions.h"
#import <AWSiOSSDK/S3/AmazonS3Client.h>

static NSString *MCAmazonAccessKey = @"AKIAIJWVQSBLQ4VY6NWQ";
static NSString *MCAmazonSecretKey = @"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";
static int MCDataSize1MB = 1048576;

@implementation MCDirectTests

- (NSString *)description
{
	return @"Test by invoking services directly from phone";
}

- (NSString *)name
{
	return @"Direct";
}

//- (NSData *)dataPredefSize:(int)size
//{
//	NSMutableData *data = [NSMutableData dataWithCapacity:size];
//	for (int i = 0; i < size/4; i++) {
//		u_int32_t randomBits = arc4random();
//		[data appendBytes:(void *)&randomBits length:sizeof(randomBits)];
//	}
//	return data;
//}
/**
 * @brief Will upload photo(s) to Amazon S3 cloud.
 *	Photos are taken from applications bundle.
 * 
 *	TODO: Provide notifications about the progress of the task.
 */
- (void)main
{
	NSData *file = [NSData randomDataOfSize:MCDataSize1MB];
	DLog(@"Data is of size : %d", [file length]);
	AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:MCAmazonAccessKey withSecretKey:MCAmazonSecretKey];
	NSString *dataKey = [NSString stringWithFormat:@"RandomData.data"];
	S3PutObjectRequest *putRequest = [[S3PutObjectRequest alloc] initWithKey:dataKey inBucket:@"maids-test-bucket"];
	putRequest.data = file;
	[s3 putObject:putRequest]; // This is a synchronous request. Next line will be executed only once object has been put to bucket. Yay!
	[putRequest release];
	[s3 release];
	
}
@end
