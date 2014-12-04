//
//  EADGroupDetailsViewController.h
//  LiveNow
//
//  Created by Pravin Khabile on 10/16/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADGroupDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *groupName;
@property (weak, nonatomic) IBOutlet UITextField *groupDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property BOOL *launchCamera;
@end
