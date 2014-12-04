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
 
    
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postman GetValueOrEmpty:_userId], @"UserId",
                                        nil];

    
 _userDetailArray= [postman Get:@"users/getbyid?jsonParams=%@" :userDataDictionary];

    if (_userDetailArray != nil)
    {
    NSDictionary *currentObject = [self.userDetailArray objectAtIndex:0];
    
    if(currentObject != nil)
    {

    
    self.userDisplayValue.text = [currentObject valueForKey:@"UserName"];
    self.userStatus.text = [currentObject valueForKey:@"UserStatus"];
    self.userLocation.text = [userDataDictionary valueForKey:@"UserLocation"];
    self.userNoOfEventsAttended.text=[NSString stringWithFormat:@"%@",[userDataDictionary valueForKey:@"UserEventAttendanceCount"]];
    self.userNoOfEventsCreated.text=[userDataDictionary valueForKey:@"UserEventAttendanceCount"];
    self.userNoOfGroupsMember.text =[userDataDictionary valueForKey:@"UserGroupsCount"];
    self.userNoOfGroupsAdmin.text =[userDataDictionary valueForKey:@"UserGroupsCount"];
        
    NSURL *imageURL = [NSURL URLWithString:[currentObject valueForKey:@"FBProfileURLBig"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
        self.userProfileImage.image=image;
    }
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
