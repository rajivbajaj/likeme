//
//  EADProfileViewController.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADProfileViewController : UITableViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *statusText;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UITextField *displayNameText;
@property (weak, nonatomic) IBOutlet UITextField *ageText;
@property (weak, nonatomic) IBOutlet UIPickerView *genderPickerView;
@property (weak, nonatomic) IBOutlet UIButton *interestsButton;
@property (weak, nonatomic) IBOutlet UITextField *genderText;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UILabel *milesLabel;

@property NSString *selectedGender;
@property NSArray *pickerData;
@property NSString *locationName;
@property double latitude;
@property double longitude;
@end
