//
//  EADUserListProfileViewController.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 11/15/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADUserListProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *userDisplayValue;
@property (weak, nonatomic) IBOutlet UILabel *userStatus;
@property (weak, nonatomic) IBOutlet UILabel *userLocation;
@property (weak, nonatomic) IBOutlet UILabel *userNoOfEventsCreated;
@property (weak, nonatomic) IBOutlet UILabel *userNoOfEventsAttended;
@property (weak, nonatomic) IBOutlet UILabel *userNoOfGroupsAdmin;
@property (weak, nonatomic) IBOutlet UILabel *userNoOfGroupsMember;
@property (strong, nonatomic)  NSString *userId;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (nonatomic, strong) NSArray *userDetailArray;
@end
