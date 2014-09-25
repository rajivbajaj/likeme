//
//  EADInboxViewController.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface EADInboxViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property BOOL newMedia;

- (IBAction)useCamera:(id)sender;


- (IBAction)useCameraRoll:(id)sender;


@end
