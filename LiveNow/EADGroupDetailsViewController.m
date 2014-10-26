//
//  EADGroupDetailsViewController.m
//  LiveNow
//
//  Created by Pravin Khabile on 10/16/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADGroupDetailsViewController.h"
#import "Postman.h"
#import "UserInfo.h"

@interface EADGroupDetailsViewController ()

@end

@implementation EADGroupDetailsViewController
@synthesize groupName;
@synthesize groupDescription;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveTouched:(id)sender {
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"saveGroupSegue"])
    {
//        GroupName = "Sports",
//        GroupDescription = "For watching or getting together to play any team sports",
//        GroupCreatedDate = DateTime.Now,
//        GroupCreatedBy = "1390318687894598",
//        IsPrivateGroup = false
        
        NSDateFormatter *foramtter = [[NSDateFormatter alloc] init];
        [foramtter setDateFormat:@"mm/dd/yyyy"];
        UserInfo *userInfo = [UserInfo sharedUserInfo];
        Postman *postMan = [Postman alloc];
        NSDictionary *groupDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [postMan GetValueOrEmpty:groupName.text], @"GroupName",
                                            [postMan GetValueOrEmpty:groupDescription.text], @"GroupDescription",
                                            [postMan GetValueOrEmpty:userInfo.userId], @"GroupCreatedBy",
                                            [foramtter stringFromDate:[NSDate date]], @"GroupCreatedDate",
                                            nil];
        
        //[postMan UserUpdate:userDataDictionary];
        [postMan Post:@"groups/post?value=%@" :groupDataDictionary];

    }
}


@end
