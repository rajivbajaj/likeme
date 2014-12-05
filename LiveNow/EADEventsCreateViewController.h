//
//  EADEventsCreateViewController.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 10/2/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADEventsCreateViewController : UITableViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *eventNameText;
@property (weak, nonatomic) IBOutlet UITextField *locationText;
@property (weak, nonatomic) IBOutlet UITextField *descriptionText;
@property (weak, nonatomic) IBOutlet UITextField *startDateText;
@property (weak, nonatomic) IBOutlet UITextField *endDateText;
@property (weak, nonatomic) IBOutlet UITextField *eventTypeText;
@property (weak, nonatomic) IBOutlet UIDatePicker *eventsDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *restrictionsText;
@property (weak, nonatomic) IBOutlet UIPickerView *restrictionsPicker;

@property NSArray *pickerData;
@property NSString *locationName;
@property double latitude;
@property double longitude;
@end
