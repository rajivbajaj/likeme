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

@interface EADProfileViewController ()

@end

@implementation EADProfileViewController

@synthesize emailText;
@synthesize statusText;
@synthesize displayNameText;
@synthesize profilePicImageView;
@synthesize location;

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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    
    Postman* postman = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    NSDictionary* userDataDictionary = [postman UserGet:userInfo.userId];
    
    emailText.text = [userDataDictionary valueForKey:@"Email"];
    statusText.text = [userDataDictionary valueForKey:@"ProfileStatus"];
    displayNameText.text = [userDataDictionary valueForKey:@"UserName"];
    location.text = userInfo.userLocation;
    
    NSURL *imageURL = [NSURL URLWithString:[userInfo profileImageURL]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    profilePicImageView.image = image;

    // Do any additional setup after loading the view.
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
                                        [postMan GetValueOrEmpty:emailText.text], @"Email",
                                        [postMan GetValueOrEmpty:statusText.text], @"ProfileStatus",
                                        [postMan GetValueOrEmpty:displayNameText.text], @"UserName",
                                        [postMan GetValueOrEmpty:location.text], @"City",
                                        nil];
    
    //[postMan UserUpdate:userDataDictionary];
    [postMan Post:@"users/post?value=%@" :userDataDictionary];
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
