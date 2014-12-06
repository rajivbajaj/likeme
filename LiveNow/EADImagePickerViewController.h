//
//  EADImagePickerViewController.h
//  LiveNow
//
//  Created by Pravin Khabile on 9/25/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface EADImagePickerViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property BOOL shouldLaunchCamera;
@property BOOL newMedia;
@property NSString* launchedFrom;
@end
