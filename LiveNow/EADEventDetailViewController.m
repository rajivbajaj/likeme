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
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    NSURL *imageURL = [NSURL URLWithString:[userInfo profileImageURL]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];

    self.userProfileImageView.image=image;
    self.eventCreaterLabel.text=@"Rajiv Bajaj";
    //self.eventCreaterLabel.text=[currentObject valueForKey:@"EventName"];
    self.eventDescriptionLabel.text=@"Open soccer game need at least 10 participants";//[currentObject valueForKey:@"EventDescription"];
    self.NoOfCommentsLabel.text=@"5";//[currentObject valueForKey:@"NumberOfMessages"];
    self.NoOfPeopleJoinedLabel.text=@"2";//[currentObject valueForKey:@"NumberOfAttendants"];

//    if (_eventArray.count >0)
//    {
//    NSDictionary *currentObject = [self.eventArray objectAtIndex:0];
//    self.eventCreaterLabel.text=[currentObject valueForKey:@"EventName"];
//    self.eventDescriptionLabel.text=[currentObject valueForKey:@"EventDescription"];
//    self.NoOfCommentsLabel.text=[currentObject valueForKey:@"NumberOfMessages"];
//    self.NoOfPeopleJoinedLabel.text=[currentObject valueForKey:@"NumberOfAttendants"];
//    }
}


- (IBAction)ClosePopUp:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
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
