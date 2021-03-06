//
//  EADEventDetailViewController.m
//  LiveNow
//
//  Created by Rajiv Bajaj on 11/2/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADEventDetailViewController.h"
#import "Postman.h"
#import "UserInfo.h"
#import "EADMessageDetailsViewController.h"
#import "EADReportAbuseViewController.h"
#import "EADEventsCreateViewController.h"
#import "EADImageViewerController.h"
@interface EADEventDetailViewController ()

@end

@implementation EADEventDetailViewController
@synthesize eventId;

bool isAttendingThisEvent = false;
bool isEventImage =false;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadEvent];
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)];
    [imageTap setNumberOfTapsRequired:1];
    [_userProfileImageView addGestureRecognizer:imageTap];
    
    UITapGestureRecognizer *eventImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleEventImageTap:)];
    [eventImageTap setNumberOfTapsRequired:1];
    [_eventImageView addGestureRecognizer:eventImageTap];
    
    self.NoOfCommentsLabel.userInteractionEnabled = NO;
    self.NoOfPeopleJoinedLabel.userInteractionEnabled = NO;
    //self.leaveEventButton.hidden = true;
}
-(void)handleImageTap:(id)sender {
    isEventImage = false;
    //[profilePicImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    [self performSegueWithIdentifier:@"eventToImageViewer" sender:sender];
}
-(void)handleEventImageTap:(id)sender {
    isEventImage = true;
    //[profilePicImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    [self performSegueWithIdentifier:@"eventToImageViewer" sender:sender];
}
- (void)loadEvent
{
    Postman *postman = [Postman alloc];
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];

    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postman GetValueOrEmpty:eventId], @"EventId",
                                        [postman GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                        nil];
    
    [postman GetAsync:@"events/getbyeventid?id=%@" :userDataDictionary
           completion:^(NSArray *dataArray)
     {
         self.self.eventArray = dataArray;
         [self populateEventData];
     }];
    
}

-(void)populateEventData
{
    if (self.eventArray != nil && self.eventArray.count >0)
    {
        
        NSDictionary *currentObject = [self.eventArray objectAtIndex:0];
        
        if(currentObject != nil)
        {
            NSURL *profileimageURL = [NSURL URLWithString:[currentObject valueForKey:@"FBProfileURL"]];
            NSData *profileimageData = [NSData dataWithContentsOfURL:profileimageURL];
            UIImage *profileimage = [UIImage imageWithData:profileimageData];
            if(profileimage != nil)
            {
                self.userProfileImageView.image = profileimage;
            }
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
                    self.eventImageView.image = image;
                }
            }
            else
            {
                [self.eventImageView setImage:[UIImage imageNamed:@"LNDefaultImage.png"]];
                self.eventImageView.contentMode = UIViewContentModeScaleAspectFit;
            }
            
            self.eventCreaterLabel.text=[currentObject valueForKey:@"UserName"];
            self.eventNameLabel.text = [currentObject valueForKey:@"EventName"];
            self.eventDescriptionLabel.text=[currentObject valueForKey:@"EventDescription"];
            
            NSInteger numberOfMsgs = [[currentObject objectForKey:@"NumberOfMessages"] integerValue];
            NSInteger numberOfAttendants = [[currentObject objectForKey:@"NumberOfAttendants"] integerValue];
            self.NoOfCommentsLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfMsgs];
            self.NoOfPeopleJoinedLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfAttendants];
            
            if([[currentObject valueForKey:@"MyAttendanceStatus"] isEqualToString:@"Yes"])
            {
                self.NoOfCommentsLabel.userInteractionEnabled = YES;
                self.NoOfPeopleJoinedLabel.userInteractionEnabled = YES;
                [self.leaveEventButton setHidden:NO];
                [self.joinEventButton setHidden:YES];
                isAttendingThisEvent = true;
                
                if([[currentObject valueForKey:@"ReportedAbuse"] isEqualToString:@"Yes"])
                {
                    [self.reportAbuseButton setHidden:YES];
                }
                else
                {
                    [self.reportAbuseButton setHidden:NO];
                }
            }
            else
            {
                self.NoOfCommentsLabel.userInteractionEnabled = NO;
                self.NoOfPeopleJoinedLabel.userInteractionEnabled = NO;
                [self.leaveEventButton setHidden:YES];
                [self.joinEventButton setHidden:NO];
                isAttendingThisEvent = false;
                [self.reportAbuseButton setHidden:NO];
            }
            
            if([[currentObject valueForKey:@"IsOwner"] isEqualToString:@"Yes"])
            {
                [self.editButton setHidden:false];
                //FOr owner hide the leave and join buttons as well
                [self.leaveEventButton setHidden:YES];
                [self.joinEventButton setHidden:YES];
            }
            else
            {
                [self.editButton setHidden:true];
                
            }
            
            
        }
        
    }
}

- (IBAction)leaveEventTouched:(id)sender
{
    [self joinOrLeaveEvent:@"No"];
    [self loadEvent];

}

- (IBAction)joinEventTouched:(id)sender
{
    [self joinOrLeaveEvent:@"Yes"];
    [self loadEvent];
}

-(void)joinOrLeaveEvent:(NSString*)attendanceStatus
{
    Postman *postman = [Postman alloc];
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postman GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                        [postman GetValueOrEmpty:eventId], @"EventId",
                                        attendanceStatus, @"AttendanceStatus",
                                        nil];
    
    [postman PostAync:@"events/joinorleave?jsonParams=%@" :userDataDictionary :@"jsonParams" completion:^(NSArray *dataArray)
     {
         [self loadEvent];
     }];
//    EADEventsViewController *eventViewController =  [self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count-2];
//    
//    eventViewController.isNewEventAdded = true;
}

- (IBAction)ClosePopUp:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)eventMessagesTouch:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     if([segue.identifier isEqualToString:@"eventMessage"])
     {
         EADMessageDetailsViewController *destinationVC = [segue destinationViewController];
         destinationVC.senderName = self.eventNameLabel.text;
         destinationVC.eventId = eventId;
         destinationVC.messangerType = @"Event";
     
     }
     else if([segue.identifier isEqualToString:@"reportAbuseSegue"])
     {
         EADReportAbuseViewController *reportAbuseViewController = segue.destinationViewController;
         
         if(reportAbuseViewController != nil)
         {
             reportAbuseViewController.entityId = self.eventId;
             reportAbuseViewController.entityType = @"event";
             reportAbuseViewController.entityName = self.eventNameLabel.text;
         }
     }
     else if([segue.identifier isEqualToString:@"eventEdit"])
     {
         EADEventsCreateViewController *eventCreateViewController = segue.destinationViewController;
         
         if(eventCreateViewController != nil)
         {
             eventCreateViewController.eventId = self.eventId;
             
         }
     }
     else if([segue.identifier isEqualToString:@"eventToImageViewer"])
     {
         EADImageViewerController *imageViewerController = [segue destinationViewController];
         if (isEventImage)
         {
         imageViewerController.imageData = _eventImageView.image;
         }
         else
         {
             imageViewerController.imageData = _userProfileImageView.image;

         }
     }

 }

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"eventMessage"] || [identifier isEqualToString:@"eventUsersSegue"])
    {
        return isAttendingThisEvent;
    }
    else
    {
        return true;
    }
}


@end
