//
//  MCMessageCell.h
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/7/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageCell.h"

@interface MCMessageCell : PageCell {
    
	UILabel *messageLabel;
}
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;

@end
