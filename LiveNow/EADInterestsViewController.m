//
//  EADInterestsViewController.m
//  LiveNow
//
//  Created by Pravin Khabile on 9/23/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADInterestsViewController.h"
#import "Postman.h"
#import "UserInfo.h"

@interface EADInterestsViewController ()

@end



@implementation EADInterestsViewController

@synthesize interestsText;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)updateIntrests:(id)sender {
    Postman* postMan = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    // update user information
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postMan GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                        [postMan GetValueOrEmpty:interestsText.text], @"UserInterests",
                                        nil];
    
    [postMan UserInterestsUpdate:userDataDictionary];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.jpg"]]];
    // Do any additional setup after loading the view.
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
