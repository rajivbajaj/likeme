//
//  EADProfileViewController.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADProfileViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *statusText;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UITextField *displayNameText;
@property (weak, nonatomic) IBOutlet UITextField *ageText;

@property NSString *locationName;
@property double latitude;
@property double longitude;
@end
