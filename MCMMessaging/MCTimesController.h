//
//  MCTimesController.h
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/9/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"

@interface MCTimesController : PageViewController {
	NSMutableArray *times;
}
@property (nonatomic, retain) NSMutableArray *times;

- (IBAction)refreshPushed:(id)sender;
- (IBAction)clearRecordsPushed:(id)sender;

@end
