//
//  EADEventsCreateViewController.m
//  LiveNow
//
//  Created by Rajiv Bajaj on 10/2/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADEventsCreateViewController.h"
#import "Postman.h"
#import "UserInfo.h"
@interface EADEventsCreateViewController ()

@end

@implementation EADEventsCreateViewController
NSString* datePickerContextText;
NSString* startDateString;
NSString* endDateString;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    self.locationText.text=userInfo.userLocation;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (IBAction)createEvent:(id)sender {
    Postman* postMan = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    
    // update event
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postMan GetValueOrEmpty:userInfo.userId], @"EventCreatedBy",
                                        [postMan GetValueOrEmpty:_eventNameText.text], @"EventName",
                                        [postMan GetValueOrEmpty:_locationText.text], @"EventCity",
                                        [postMan GetValueOrEmpty:_descriptionText.text], @"EventDescription",
                                        [postMan GetValueOrEmpty:startDateString], @"StartTime",
                                        [postMan GetValueOrEmpty:endDateString], @"EndTime",
                                        [postMan GetValueOrEmpty:_eventTypeText.text], @"EventType",
                                        nil];
    
    
    [postMan Post:@"events/post?value=%@" :userDataDictionary];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if([segue.identifier isEqualToString:@"eventSaveSegue"])
//    {
//
//    }
//}

- (IBAction)datePickerValueChanged:(id)sender
{
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[self.eventsDatePicker date]
                                                            dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString *sqlDate = [dateFormatter stringFromDate: [self.eventsDatePicker date]];
    
    if([datePickerContextText isEqualToString:@"start"])
    {
        [self.startDateText setText:dateString];
        startDateString = sqlDate;
    }
    else if([datePickerContextText isEqualToString:@"end"])
    {
        [self.endDateText setText:dateString];
        endDateString = sqlDate;
    }
}

- (IBAction)startDateStartEditing:(id)sender
{
    datePickerContextText = @"start";
    [self datePickerContext:[self.startDateText text]];
}

- (IBAction)endDateStartEditing:(id)sender
{
    datePickerContextText = @"end";
    [self datePickerContext:[self.endDateText text]];
}

-(void)datePickerContext:(NSString*)selectedDate
{
    [self.eventsDatePicker setHidden:false];
    
    if(![selectedDate isEqualToString:@""])
    {
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateStyle:NSDateFormatterShortStyle];
        [dateFormat setTimeStyle:NSDateFormatterShortStyle];
        NSDate *date = [dateFormat dateFromString:selectedDate];
        
        [self.eventsDatePicker setDate:date];
    }
}


@end
