//
//  EADProfileViewController.m
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADProfileViewController.h"
#import "Postman.h"
#import "UserInfo.h"
#import "EADLocationSearchViewController.h"

@interface EADProfileViewController ()

@end

@implementation EADProfileViewController

@synthesize ageText;
@synthesize statusText;
@synthesize displayNameText;
@synthesize profilePicImageView;
@synthesize location;

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super init];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

//
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)updateProfile:(id)sender {
    Postman* postMan = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    // update user information
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postMan GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                        //[postMan GetValueOrEmpty:ageText.text], @"Age",
                                        [postMan GetValueOrEmpty:statusText.text], @"ProfileStatus",
                                        [postMan GetValueOrEmpty:displayNameText.text], @"UserName",
                                        [postMan GetValueOrEmpty:location.text], @"City",
                                        nil];
    
    //[postMan UserUpdate:userDataDictionary];
    [postMan Post:@"users/post?value=%@" :userDataDictionary];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    
    Postman* postman = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    NSDictionary* userDataDictionary = [postman UserGet:userInfo.userId];
    
    //ageText.text = [userDataDictionary valueForKey:@"Age"];
    statusText.text = [userDataDictionary valueForKey:@"ProfileStatus"];
    displayNameText.text = [userDataDictionary valueForKey:@"UserName"];
    if(userInfo.userLocation != nil && ![userInfo.userLocation isEqualToString:@""])
    {
        location.text = userInfo.userLocation;
    }
    else
    {
        location.text = [userDataDictionary valueForKey:@"City"];
    }
    
    NSURL *imageURL = [NSURL URLWithString:[userInfo profileImageURL]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36,36), YES, 0);
    [image drawInRect:CGRectMake(0,0,36,36)];
    UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    profilePicImageView.image = im2;
    profilePicImageView.contentMode = UIViewContentModeTop;
    
    //profilePicImageView.image = image;

    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    if(![self.locationName isEqualToString:@""])
    {
        self.location.text = self.locationName;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)updateProfileTouch:(id)sender
{
    Postman* postMan = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];

    // update user information
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postMan GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                        [postMan GetValueOrEmpty:ageText.text], @"Age",
                                        [postMan GetValueOrEmpty:statusText.text], @"ProfileStatus",
                                        [postMan GetValueOrEmpty:displayNameText.text], @"UserName",
                                        [postMan GetValueOrEmpty:location.text], @"City",
                                        _latitude, @"Latitude",
                                        _longitude, @"Longitude",
                                        nil];
    
    [postMan Post:@"users/post?value=%@" :userDataDictionary];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segueLocationPicker"])
    {
        EADLocationSearchViewController *locationSearchController = [segue destinationViewController];
        
        locationSearchController.initiatingController = @"profile";
    }
}


@end
