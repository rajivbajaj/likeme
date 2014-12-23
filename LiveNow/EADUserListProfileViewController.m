//
//  EADUserListProfileViewController.m
//  LiveNow
//
//  Created by Rajiv Bajaj on 11/15/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADUserListProfileViewController.h"
#import "Postman.h"
#import "UserInfo.h"
#import "EADMessageDetailsViewController.h"
#import "EADReportAbuseViewController.h"

@interface EADUserListProfileViewController ()

@end

@implementation EADUserListProfileViewController
@synthesize userDisplayValue;
@synthesize userStatus;
@synthesize userLocation;
@synthesize userNoOfEventsAttended;
@synthesize userNoOfEventsCreated;
@synthesize userNoOfGroupsMember;
@synthesize userNoOfGroupsAdmin;
@synthesize userProfileImage;
@synthesize userInterestsLabel;


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
    [self loadUserProfile];
}

-(void) loadUserProfile
{
    Postman* postman = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postman GetValueOrEmpty:_userId], @"UserId",
                                        userInfo.userId, @"AuthenticationToken",
                                        nil];

    
 _userDetailArray= [postman Get:@"users/getbyid?jsonParams=%@" :userDataDictionary];

    if (_userDetailArray != nil)
    {
    NSDictionary *currentObject = [self.userDetailArray objectAtIndex:0];
    
        if(currentObject != nil)
        {
            self.userDisplayValue.text = [currentObject valueForKey:@"DisplayName"];
            self.userStatus.text = [currentObject valueForKey:@"ProfileStatus"];
            self.userLocation.text = [currentObject valueForKey:@"City"];
            self.userInterestsLabel.text = [currentObject valueForKey:@"UserInterests"];
                
            NSInteger numberOfEventsCreated = [[currentObject objectForKey:@"UserEventAttendanceCount"] integerValue];
            NSInteger numberOfEventsAttending = [[currentObject objectForKey:@"UserEventAttendanceCount"] integerValue];
            NSInteger numberOfUserGroupCount = [[currentObject objectForKey:@"UserGroupsCount"] integerValue];
            NSInteger numberOfGroupAdmin = [[currentObject objectForKey:@"UserGroupsCount"] integerValue];
                
            self.userNoOfEventsAttended.text=[NSString stringWithFormat:@"%ld",(long)numberOfEventsAttending];
                self.userNoOfEventsCreated.text=[NSString stringWithFormat:@"%ld",(long)numberOfEventsCreated];

                self.userNoOfGroupsMember.text =[NSString stringWithFormat:@"%ld",(long)numberOfUserGroupCount];
            self.userNoOfGroupsAdmin.text =[NSString stringWithFormat:@"%ld",(long)numberOfGroupAdmin];
                
            NSURL *imageURL = [NSURL URLWithString:[currentObject valueForKey:@"FBProfileURLBig"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:imageData];
                self.userProfileImage.image=image;
            
            if([[currentObject valueForKey:@"ReportedAbuse"] isEqualToString:@"Yes"])
            {
                [self.reportAbuseButton setHidden:YES];
            }
            else
            {
                [self.reportAbuseButton setHidden:NO];
            }
        }
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"userProfileToMessage"])
    {
        EADMessageDetailsViewController *destinationVC = [segue destinationViewController];
        if (_userDetailArray != nil)
        {
            NSDictionary *currentObject = [self.userDetailArray objectAtIndex:0];
            
        
            destinationVC.senderName = [currentObject valueForKey:@"DisplayName"];;
        
            destinationVC.authorId = [currentObject valueForKey:@"UserId"];;
            destinationVC.messangerType = @"User";
        }
    }
    else if([segue.identifier isEqualToString:@"reportAbuseSegue"])
    {
        EADReportAbuseViewController *reportAbuseViewController = segue.destinationViewController;
        
        if(reportAbuseViewController != nil)
        {
            reportAbuseViewController.entityId = self.userId;
            reportAbuseViewController.entityType = @"user";
            reportAbuseViewController.entityName = self.userDisplayValue.text;
        }
    }

}


@end
