//
//  EADEventsCreateViewController.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 10/2/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADEventsCreateViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *eventNameText;
@property (weak, nonatomic) IBOutlet UITextField *locationText;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDate;
@property (weak, nonatomic) IBOutlet UITextField *startDateText;
@property (weak, nonatomic) IBOutlet UITextField *endDateText;
- (IBAction)saveEvent:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *eventTypeText;

@end
