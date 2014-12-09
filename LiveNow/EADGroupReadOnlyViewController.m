//
//  EADGroupReadOnlyViewController.m
//  LiveNow
//
//  Created by Pravin Khabile on 12/5/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import "EADGroupReadOnlyViewController.h"
#import "Postman.h"
#import "UserInfo.h"
#import "EADMessageDetailsViewController.h"

@interface EADGroupReadOnlyViewController ()

@end

@implementation EADGroupReadOnlyViewController
@synthesize groupId;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadGroupDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadGroupDetails
{
    Postman *postman = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postman GetValueOrEmpty:groupId], @"GroupId",
                                        [postman GetValueOrEmpty:userInfo.userId], @"AuthenticationToken",
                                        nil];
    
    self.groupDetailsArray = [postman Get:@"groups/getbygroupid?jsonParams=%@" :userDataDictionary];
    
    if(self.groupDetailsArray != nil && self.groupDetailsArray.count > 0)
    {
        NSDictionary *currentObject = [self.groupDetailsArray objectAtIndex:0];
        
        if(currentObject != nil)
        {
            self.groupNameLabel.text = [currentObject valueForKey:@"GroupName"];
            self.groupDescriptionLabel.text = [currentObject valueForKey:@"GroupDescription"];
            
            NSInteger numberOfMsgs = [[currentObject objectForKey:@"GroupMessagesCount"] integerValue];
            NSInteger numberOfMembers = [[currentObject objectForKey:@"GroupMembersCount"] integerValue];
            self.groupMessagesCountLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfMsgs];
            self.groupMemberCountLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfMembers];
            
            // If user is owner of the group don't show the join or leave buttons
            if([[currentObject valueForKey:@"IsOwner"] isEqualToString:@"Yes"])
            {
                [self.joinGroupButton setHidden:YES];
                [self.leaveGroupButton setHidden:YES];
                [self.messagesSegueButton setEnabled:YES];
                [self.usersSegueButton setEnabled:YES];
            }
            else if([[currentObject valueForKey:@"IsMember"] isEqualToString:@"Yes"])
            {
                [self.leaveGroupButton setHidden:NO];
                [self.joinGroupButton setHidden:YES];
                [self.messagesSegueButton setEnabled:YES];
                [self.usersSegueButton setEnabled:YES];
            }
            else
            {
                [self.joinGroupButton setHidden:NO];
                [self.leaveGroupButton setHidden:YES];
                [self.messagesSegueButton setEnabled:NO];
                [self.usersSegueButton setEnabled:NO];
            }
        }
    }
}
- (IBAction)joinGroupTouched:(id)sender
{
    Postman *postman = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postman GetValueOrEmpty:groupId], @"GroupId",
                                        [postman GetValueOrEmpty:userInfo.userId], @"UserAuthToken",
                                        @"A", @"GroupUserStatus",
                                        nil];
    
    self.groupDetailsArray = [postman Get:@"groups/joinorleavegroup?jsonParams=%@" :userDataDictionary];
    [self loadGroupDetails];
}

- (IBAction)leaveGroupTouched:(id)sender
{
    Postman *postman = [Postman alloc];
    UserInfo *userInfo = [UserInfo sharedUserInfo];

    NSDictionary *userDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [postman GetValueOrEmpty:groupId], @"GroupId",
                                        [postman GetValueOrEmpty:userInfo.userId], @"UserAuthToken",
                                        @"I", @"GroupUserStatus",
                                        nil];
    
    self.groupDetailsArray = [postman Get:@"groups/joinorleavegroup?jsonParams=%@" :userDataDictionary];
    [self loadGroupDetails];
}


#pragma mark - Navigation

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL canSegue = false;
    if([identifier isEqualToString:@"groupMessagesSegue"] || [identifier isEqualToString:@"groupUsersSegue"])
    {
        canSegue = self.messagesSegueButton.isEnabled;
    }
    else
    {
        canSegue = true;
    }
    return canSegue;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"groupMessagesSegue"])
    {
        EADMessageDetailsViewController *messageDetailsViewController = segue.destinationViewController;
        
        if(messageDetailsViewController != nil)
        {
            messageDetailsViewController.senderDisplayName = [self.groupNameLabel text];
            messageDetailsViewController.messangerType = @"Group";
            messageDetailsViewController.groupId = self.groupId;
        }
    }
}


@end
