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

@property (weak, nonatomic) IBOutlet UILabel *eventDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *NoOfCommentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *NoOfPeopleJoinedLabel;
@property (strong, nonatomic)  NSString *eventId;
@property (nonatomic, strong) NSArray *eventArray;
@end
