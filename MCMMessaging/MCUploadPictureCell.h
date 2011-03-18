//
//  MCUploadPictureCell.h
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/4/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageCell.h"

@class MCTask;
@interface MCUploadPictureCell : PageCell <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    @private
	BOOL hasPickedImage;
	UILabel *taskNameLabel;
	UITableView *parentTable;
	UIButton *thumbnailImage;
	UIButton *actionButton;
	MCTask *uploadPictureTask;
}

@property (nonatomic, retain) IBOutlet UILabel *taskNameLabel;
@property (nonatomic, assign) UITableView *parentTable;
@property (nonatomic, retain) IBOutlet UIButton *thumbnailImage;
@property (nonatomic, retain) IBOutlet UIButton *actionButton;

- (IBAction)takePicturePressed:(id)sender;

@end
