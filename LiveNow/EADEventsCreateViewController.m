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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    self.locationText.text=userInfo.userLocation;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
  //  return 0;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
  //  return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"eventSaveSegue"])
    {
        Postman* postMan = [Postman alloc];
        UserInfo *userInfo = [UserInfo sharedUserInfo];
        
        // update event
        NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [postMan GetValueOrEmpty:userInfo.userId], @"EventCreatedBy",
                                            [postMan GetValueOrEmpty:_eventNameText.text], @"EventName",
                                            [postMan GetValueOrEmpty:_locationText.text], @"EventCity",
                                            [postMan GetValueOrEmpty:_descriptionText.text], @"EventDescription",
                                            [postMan GetValueOrEmpty:_startDateText.text], @"StartTime",
                                            [postMan GetValueOrEmpty:_endDateText.text], @"EndTime",
                                            [postMan GetValueOrEmpty:_eventTypeText.text], @"EventType",
                                            nil];
        
        
        [postMan Post:@"events/post?value=%@" :userDataDictionary];

    }
}

- (IBAction)datePickerValueChanged:(id)sender
{
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[self.eventsDatePicker date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    
    if([datePickerContextText isEqualToString:@"start"])
    {
        [self.startDateText setText:dateString];
    }
    else if([datePickerContextText isEqualToString:@"end"])
    {
        [self.endDateText setText:dateString];
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

- (IBAction)saveEvent:(id)sender {
//    Postman* postMan = [Postman alloc];
//    UserInfo *userInfo = [UserInfo sharedUserInfo];
//    
//    // update event
//    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                        [postMan GetValueOrEmpty:userInfo.userId], @"EventCreatedBy",
//                                        [postMan GetValueOrEmpty:_eventNameText.text], @"EventName",
//                                        [postMan GetValueOrEmpty:_locationText.text], @"EventCity",
//                                        [postMan GetValueOrEmpty:_descriptionText.text], @"EventDescription",
//                                        [postMan GetValueOrEmpty:_startDateText.text], @"StartTime",
//                                        [postMan GetValueOrEmpty:_endDateText.text], @"EndTime",
//                                        [postMan GetValueOrEmpty:_eventTypeText.text], @"EventType",
//                                        nil];
//    
//    
//       [postMan Post:@"events/post?value=%@" :userDataDictionary];
    //[self prepareForSegue: sender:<#(id)#>]
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
