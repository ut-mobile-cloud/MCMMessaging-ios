//
//  MCUploadPictureCell.m
//  MCMMessaging
//
//  Created by Madis Nõmme on 3/4/11.
//  Copyright 2011 MobileCloud. All rights reserved.
//

#import "MCUploadPictureCell.h"
#import "MCTask.h"
#import "MCTaskRunner.h"

@implementation MCUploadPictureCell
@synthesize thumbnailImage;
@synthesize actionButton;
@synthesize taskNameLabel, parentTable;

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissModalViewControllerAnimated:YES];
	hasPickedImage = NO;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissModalViewControllerAnimated:YES];
	UIImage *selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	[self.thumbnailImage.imageView setImage:selectedImage];
	[self.thumbnailImage.imageView setContentMode:UIViewContentModeScaleAspectFit];
	NSData *imageData = UIImagePNGRepresentation(selectedImage);
	uploadPictureTask.data = imageData;
	hasPickedImage = YES;
	[picker dismissModalViewControllerAnimated:YES];
}

+ (NSString *)nibName
{
	return @"MCUploadPictureCell";
}

- (void)dealloc {
	[taskNameLabel release];
    [thumbnailImage release];
	[actionButton release];
	[super dealloc];
}
- (IBAction)takePicturePressed:(id)sender {
	DLog(@"Take picture pressed");
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[(PageViewController *)self.parentTable.delegate presentModalViewController:imagePicker animated:YES];
	[imagePicker release];
}

- (void)configureForData:(id)dataObject tableView:(UITableView *)aTableView indexPath:(NSIndexPath *)anIndexPath
{
	[super configureForData:dataObject tableView:aTableView indexPath:anIndexPath];
	parentTable = aTableView;
	uploadPictureTask = (MCTask *)[dataObject retain];
	self.taskNameLabel.text = uploadPictureTask.description;
}

- (void)handleSelectionInTableView:(UITableView *)aTableView
{
	[super handleSelectionInTableView:aTableView];
	DLog(@"Will run uploadImageTask");
	if(hasPickedImage) {
		[MCTaskRunner runTask:uploadPictureTask];
	} else {
		[self takePicturePressed:nil];
	}
}

@end
