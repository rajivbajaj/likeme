//
//  EADEventDetailViewController.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 11/2/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADEventDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *eventCreaterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *eventDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *NoOfCommentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *NoOfPeopleJoinedLabel;
@property (strong, nonatomic)  NSString *eventId;
@property (nonatomic, strong) NSArray *eventArray;
@property (weak, nonatomic) IBOutlet UIButton *leaveEventButton;
@property (weak, nonatomic) IBOutlet UIButton *reportAbuseButton;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UIButton *joinEventButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end
