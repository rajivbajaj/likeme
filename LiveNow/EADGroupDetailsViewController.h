//
//  EADGroupDetailsViewController.h
//  LiveNow
//
//  Created by Pravin Khabile on 10/16/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADGroupDetailsViewController : UITableViewController<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *groupName;
@property (weak, nonatomic) IBOutlet UITextField *groupDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIPickerView *restrictionsPicker;
@property (weak, nonatomic) IBOutlet UITextField *restrictionsText;
@property (weak, nonatomic) IBOutlet UISwitch *groupStatusSwitch;
@property (weak, nonatomic) IBOutlet UILabel *groupStatusLabel;
@property NSArray *pickerData;
@property BOOL launchCamera;
@property (strong, nonatomic)  NSString *groupId;
@property (nonatomic, strong) NSArray *groupDetailsArray;
@end
