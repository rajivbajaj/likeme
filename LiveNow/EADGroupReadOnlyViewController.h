//
//  EADGroupReadOnlyViewController.h
//  LiveNow
//
//  Created by Pravin Khabile on 12/5/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADGroupReadOnlyViewController : UITableViewController
@property (strong, nonatomic)  NSString *groupId;
@property (nonatomic, strong) NSArray *groupDetailsArray;

@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupMemberCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupMessagesCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *leaveGroupButton;
@property (weak, nonatomic) IBOutlet UIButton *joinGroupButton;
@property (weak, nonatomic) IBOutlet UIButton *messagesSegueButton;
@property (weak, nonatomic) IBOutlet UIButton *usersSegueButton;
@property (weak, nonatomic) IBOutlet UIButton *reportAbuseButton;
@property (weak, nonatomic) IBOutlet UILabel *groupLocationName;
@end
