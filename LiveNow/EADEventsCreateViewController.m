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
#import "EADLocationSearchViewController.h"
#import "EADEventsViewController.h"
#import "EADImagePickerViewController.h"
#import "HumanInterfaceUtility.h"
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
    [self.view setBackgroundColor:[HumanInterfaceUtility colorWithHexString:@"C0CFD6"]];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    self.locationText.text=userInfo.userLocation;
    
    Postman* postman = [Postman alloc];
    
    NSDictionary *paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"EventRestrictions", @"LKGroupName",
                                      nil];
    
    self.pickerData = [postman Get:@"utility/get?jsonParams=%@" :paramsDictionary];
    if (_eventId != nil)
    {
        [self loadEvent];
    }
//    UIImage *btnImage = _imageView.image;
//    [_cameraButton setImage:btnImage forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(![self.locationName isEqualToString:@""])
    {
        self.locationText.text = self.locationName;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (IBAction)createEvent:(id)sender {
    if ([[self.eventNameText text]  isEqual:@""])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"please fill the event name first"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        //[alert release];
        
        
    }
    else if ([[self.locationText text] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"please fill the event location"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([[self.startDateText text] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"please fill the event start date"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {

    Postman* postMan = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    
    NSString *latitudeString = [[NSNumber numberWithDouble:self.latitude] stringValue];
    NSString *longitudeString = [[NSNumber numberWithDouble:self.longitude] stringValue];
    
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.7);
    // update event
    NSDictionary *eventDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postMan GetValueOrEmpty:userInfo.userId], @"EventCreatedBy",
                                        [postMan GetValueOrEmpty:_eventNameText.text], @"EventName",
                                        [postMan GetValueOrEmpty:_locationText.text], @"EventCity",
                                        [postMan GetValueOrEmpty:_descriptionText.text], @"EventDescription",
                                        [postMan GetValueOrEmpty:startDateString], @"StartTime",
                                        [postMan GetValueOrEmpty:endDateString], @"EndTime",
                                        [postMan GetValueOrEmpty:_eventTypeText.text], @"EventType",
                                        [postMan GetValueOrEmpty:_eventStatusText.text], @"EventStatus",
                                        latitudeString, @"Latitude",
                                        longitudeString, @"Longitude",
                                        [postMan GetValueOrEmpty:_eventStatusText.text], @"EventStatus",
                                         _eventId, @"EventId",
                                        nil];
    
    
    //[postMan Post:@"events/post?value=%@" :eventDataDictionary];
    [postMan PostWithFileData:@"events/post" :eventDataDictionary :imageData];
        if (_eventId == nil) {
            EADEventsViewController *eventViewController =  [self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count-2];
            
            eventViewController.isNewEventAdded = true;
        }
        else
        {
            EADEventsViewController *eventViewController =  [self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count-3];
            
            eventViewController.isNewEventAdded = true;
        }
        

    
    [self.navigationController popViewControllerAnimated:YES];
    }
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segueLocationPicker"])
    {
        EADLocationSearchViewController *locationSearchController = segue.destinationViewController;
        
        locationSearchController.initiatingController = @"event";
    }
    else if([segue.identifier isEqualToString:@"eventToImagePicker"])
    {
        EADImagePickerViewController *destinationVC = [segue destinationViewController];
        destinationVC.launchedFrom = @"Event";
        destinationVC.shouldLaunchCamera=_launchCamera;
        
    }

}

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
    [self.restrictionsPicker setHidden:true];
    [sender resignFirstResponder];
    datePickerContextText = @"start";
    [self datePickerContext:[self.startDateText text]];
}

- (IBAction)endDateStartEditing:(id)sender
{
    [self.restrictionsPicker setHidden:true];
    [sender resignFirstResponder];
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

- (IBAction)restrictionsEditingBegin:(id)sender
{
    //Hide the datepicker
    [self.eventsDatePicker setHidden:true];
    [sender resignFirstResponder];
    [self.restrictionsPicker setHidden:false];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *currentObject = [self.pickerData objectAtIndex:row];
    NSString *title;

    if(currentObject != nil)
    {
        title = [currentObject valueForKey:@"DisplayValue"];
    }

    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSDictionary *currentObject = _pickerData[row];
    
    if(currentObject != nil)
    {
        self.restrictionsText.text = [currentObject valueForKey:@"DisplayValue"];
    }
}

- (IBAction)genericTouchDown:(id)sender {
    // hide both pickers becauase these textfields don't need any pickers
    [self.eventsDatePicker setHidden:true];
    [self.restrictionsPicker setHidden:true];
}
- (IBAction)actionInitiatorTouched:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [actionSheet addButtonWithTitle:@"Take a Picture"];
    [actionSheet addButtonWithTitle:@"Camera Roll"];
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            break;
        case 1:
            _launchCamera = true;
            [self performSegueWithIdentifier:@"eventToImagePicker" sender:self];
            break;
        case 2:
            _launchCamera = false;
            [self performSegueWithIdentifier:@"eventToImagePicker" sender:self];
            break;
        default:
            break;
    }
}

- (IBAction)eventStatusValueChanged:(id)sender
{
    if(self.eventStatus.isOn == true)
    {
        self.eventStatusText.text = @"Active";
    }
    else if(self.eventStatus.isOn == false)
    {
        self.eventStatusText.text = @"Inactive";
    }
}
- (void)loadEvent
{
    Postman *postman = [Postman alloc];
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postman GetValueOrEmpty:_eventId], @"EventId",
                                        [postman GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                        nil];
    
    self.eventArray = [postman Get:@"events/getbyeventid?id=%@" :userDataDictionary];
    
    if (self.eventArray != nil && self.eventArray.count >0)
    {
        
        NSDictionary *currentObject = [self.eventArray objectAtIndex:0];
        
        if(currentObject != nil)
        {
//            NSURL *profileimageURL = [NSURL URLWithString:[currentObject valueForKey:@"FBProfileURL"]];
//            NSData *profileimageData = [NSData dataWithContentsOfURL:profileimageURL];
//            UIImage *profileimage = [UIImage imageWithData:profileimageData];
//            if(profileimage != nil)
//            {
//                self.imageView.image = profileimage;
//            }
            NSString *imageStringData = [currentObject valueForKey:@"EventPic"];
            
            if(imageStringData != nil && ![imageStringData isEqualToString:@""])
            {
                NSData *imageData;
                
                if ([NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)])
                {
                    imageData = [[NSData alloc] initWithBase64EncodedString:imageStringData options:kNilOptions];  // iOS 7+
                }
                
                if(imageData != nil)
                {
                    UIImage *image = [UIImage imageWithData:imageData];
                    self.imageView.image = image;
                }
            }
            
           // self.eventCreaterLabel.text=[currentObject valueForKey:@"UserName"];
            self.eventNameText.text = [currentObject valueForKey:@"EventName"];
            self.descriptionText.text=[currentObject valueForKey:@"EventDescription"];
            self.locationText.text =[currentObject valueForKey:@"EventCity"];
             self.restrictionsText.text =[currentObject valueForKey:@"location"];
             self.startDateText.text =[currentObject valueForKey:@"StartTime"];
             self.endDateText.text =[currentObject valueForKey:@"EndTime"];
             self.eventTypeText.text =[currentObject valueForKey:@"EventType"];
            
            if ([[currentObject valueForKey:@"EventStatus"]  isEqual: @"Active"])
            {
                [self.eventStatus setOn:true];
            }
            else
            {
                 [self.eventStatus setOn:false];
            }
           // NSInteger numberOfMsgs = [[currentObject objectForKey:@"NumberOfMessages"] integerValue];
            //NSInteger numberOfAttendants = [[currentObject objectForKey:@"NumberOfAttendants"] integerValue];
           // self.NoOfCommentsLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfMsgs];
            //self.NoOfPeopleJoinedLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfAttendants];
            
            
            
        }
        
    }
}


@end
