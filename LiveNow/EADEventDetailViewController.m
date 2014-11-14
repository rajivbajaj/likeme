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

@interface EADEventDetailViewController ()

@end

@implementation EADEventDetailViewController
@synthesize eventId;

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
}
- (void)loadEvent
{
    Postman *postman = [Postman alloc];
    
    //UserInfo *userInfo = [UserInfo sharedUserInfo];
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postman GetValueOrEmpty:eventId], @"EventId",
                                       
                                        nil];
    
    self.eventArray = [postman Get:@"events/getbyeventid?id=%@" :userDataDictionary];
    
    if (self.eventArray != nil && self.eventArray.count >0)
    {
        
        NSDictionary *currentObject = [self.eventArray objectAtIndex:0];
        
        if(currentObject != nil)
        {
            NSURL *imageURL = [NSURL URLWithString:[currentObject valueForKey:@"FBProfileURL"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:imageData];
            
            self.userProfileImageView.image=image;

            self.eventCreaterLabel.text=[currentObject valueForKey:@"UserName"];
            self.eventNameLabel.text = [currentObject valueForKey:@"EventName"];
            self.eventDescriptionLabel.text=[currentObject valueForKey:@"EventDescription"];

            NSInteger numberOfMsgs = [[currentObject objectForKey:@"NumberOfMessages"] integerValue];
            NSInteger numberOfAttendants = [[currentObject objectForKey:@"NumberOfAttendants"] integerValue];
            self.NoOfCommentsLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfMsgs];
            self.NoOfPeopleJoinedLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfAttendants];
        }
        
    }
}
- (IBAction)joinEventTouched:(id)sender
{
    Postman *postman = [Postman alloc];
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postman GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                        [postman GetValueOrEmpty:eventId], @"EventId",
                                        @"Yes", @"AttendanceStatus",
                                        nil];
    
    [postman Post:@"events/join?jsonParams=%@" :userDataDictionary];
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
 }


@end
