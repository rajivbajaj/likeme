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
#import "EADReportAbuseViewController.h"

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
            
            
            //NSData *imageData = [NSData dataWithBytes:[currentObject valueForKey:@"GroupPic"] length:<#(NSUInteger)#>
            NSString *imageStringData = [currentObject valueForKey:@"GroupPic"];

            if(imageStringData != nil)
            {
                NSData *imageData = [self parseStringToData:imageStringData];
                UIImage *image = [UIImage imageWithData:imageData];
                
                                UIGraphicsBeginImageContextWithOptions(CGSizeMake(36,36), YES, 0);
                                [image drawInRect:CGRectMake(0,0,36,36)];
                                UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
                                self.groupImageView .image = im2;

            }
//            if(imageData != nil)
//            {
//                byte[]
//                UIImage *image = [UIImage imageWithData:[currentObject valueForKey:@"GroupPic"]];
//                
//                UIGraphicsBeginImageContextWithOptions(CGSizeMake(36,36), YES, 0);
//                [image drawInRect:CGRectMake(0,0,36,36)];
//                UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
//                UIGraphicsEndImageContext();
//                self.groupImageView .image = im2;
//            }
            
            // If user is owner of the group don't show the join or leave buttons
            if([[currentObject valueForKey:@"IsOwner"] isEqualToString:@"Yes"])
            {
                [self.joinGroupButton setHidden:YES];
                [self.leaveGroupButton setHidden:YES];
                [self.messagesSegueButton setEnabled:YES];
                [self.usersSegueButton setEnabled:YES];
                [self.reportAbuseButton setHidden:YES];

            }
            else if([[currentObject valueForKey:@"IsMember"] isEqualToString:@"Yes"])
            {
                [self.leaveGroupButton setHidden:NO];
                [self.joinGroupButton setHidden:YES];
                [self.messagesSegueButton setEnabled:YES];
                [self.usersSegueButton setEnabled:YES];
                if([[currentObject valueForKey:@"ReportedAbuse"] isEqualToString:@"Yes"])
                {
                    [self.reportAbuseButton setHidden:YES];
                }
                else
                {
                    [self.reportAbuseButton setHidden:NO];
                }
            }
            else
            {
                [self.joinGroupButton setHidden:NO];
                [self.leaveGroupButton setHidden:YES];
                [self.messagesSegueButton setEnabled:NO];
                [self.usersSegueButton setEnabled:NO];
                [self.reportAbuseButton setHidden:YES];
            }
        }
    }
}

- (NSData *) parseStringToData:(NSString *) str
{
    if ([str length] % 3 != 0)
    {
        // raise an exception, because the string's length should be a multiple of 3.
    }
    
    NSMutableData *result = [NSMutableData dataWithLength:[str length] / 3];
    unsigned char *buffer = [result mutableBytes];
    
    for (NSUInteger i = 0; i < [result length]; i++)
    {
        NSString *byteString = [str substringWithRange:NSMakeRange(i * 3, 3)];
        buffer[i] = [byteString intValue];
    }
    
    return result;
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
    else if([segue.identifier isEqualToString:@"reportAbuseSegue"])
    {
        EADReportAbuseViewController *reportAbuseViewController = segue.destinationViewController;
        
        if(reportAbuseViewController != nil)
        {
            reportAbuseViewController.entityId = self.groupId;
            reportAbuseViewController.entityType = @"group";
            reportAbuseViewController.entityName = self.groupNameLabel.text;
        }
    }
}


@end
